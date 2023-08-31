"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileController = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("@nestjs/axios");
const stream_1 = require("stream");
const rxjs_1 = require("rxjs");
const file_service_1 = require("./file.service");
const ffmpegPath = require('@ffmpeg-installer/ffmpeg').path;
const ffmpeg = require('fluent-ffmpeg');
ffmpeg.setFfmpegPath(ffmpegPath);
const fs = require('fs');
const crypto = require('crypto').webcrypto;
const jwt = require('jsonwebtoken');
const util = require('util');
async function generateSecretKeyForEncryption(secreteKeyString, userSalt) {
    const key = await crypto.subtle.importKey('raw', new TextEncoder().encode(secreteKeyString), { name: 'PBKDF2', hash: 'SHA-256' }, false, ['deriveKey']);
    const derivedKey = await crypto.subtle.deriveKey({
        name: 'PBKDF2',
        salt: new TextEncoder().encode(userSalt),
        iterations: 1000,
        hash: 'SHA-256',
    }, key, { name: 'AES-GCM', length: 256 }, true, ['encrypt', 'decrypt']);
    return derivedKey;
}
const fromHexString = (hexString) => Uint8Array.from(hexString.match(/.{1,2}/g).map((byte) => parseInt(byte, 16)));
const decryptedSecretKeyAndFile = async (data, secretKey, accessKey, iv, fileData, userSalt) => {
    const newDataArray = fromHexString(data);
    const key = await generateSecretKeyForEncryption(secretKey, userSalt);
    const encryptionKey = await crypto.subtle.decrypt({
        name: 'AES-GCM',
        iv: new TextEncoder().encode(accessKey),
        tagLength: 128,
    }, key, newDataArray);
    const ecnryptionKeyForFile = await crypto.subtle.importKey('raw', new Uint8Array(encryptionKey), { name: 'AES-GCM' }, true, ['encrypt', 'decrypt']);
    const encrtedData = await crypto.subtle.decrypt({ name: 'AES-GCM', iv: new TextEncoder().encode(iv) }, ecnryptionKeyForFile, fileData);
    return encrtedData;
};
let FileController = class FileController {
    constructor(httpService, fileService) {
        this.httpService = httpService;
        this.fileService = fileService;
        this.fileService.saveNodeOsDetails();
    }
    async getStatus(res, _params, _req) {
        const cluster = await this.fileService.getClusterId();
        const clusterId = (cluster === null || cluster === void 0 ? void 0 : cluster.addresses[cluster.addresses.length - 1]) || null;
        return res.send({ isClusterOnline: !!clusterId });
    }
    async playVideo(res, params, req) {
        try {
            const { accessKey, token } = params;
            const accessDataResponse = await (0, rxjs_1.firstValueFrom)(this.httpService
                .post(`${process.env.API_SERVER_URL}/file/access/verify-token`, {
                accessKey,
                token,
            })
                .pipe((0, rxjs_1.map)((response) => {
                return response.data;
            })));
            const accessData = accessDataResponse === null || accessDataResponse === void 0 ? void 0 : accessDataResponse.data;
            const ipfsMetaData = accessData.fileMetaData.sort(function (a, b) {
                return a.index - b.index;
            });
            const path = `videos/${accessData.accessKey}${accessData.fileName}`;
            if (!fs.existsSync(path)) {
                const writableStream = fs.createWriteStream(path);
                for (let i = 0; i < ipfsMetaData.length; i++) {
                    const fileRespone = await (0, rxjs_1.firstValueFrom)(this.httpService
                        .get(`http://46.101.133.110:8080/api/v0/cat/${ipfsMetaData[i].cid}`, {
                        responseType: 'arraybuffer',
                    })
                        .pipe((0, rxjs_1.map)((response) => {
                        return response.data;
                    })));
                    const decryptedData = await decryptedSecretKeyAndFile(accessData.data, accessData.secretKey, accessData.accessKey, accessData.iv, fileRespone, accessData.salt);
                    await writableStream.write(Buffer.from(decryptedData));
                }
                writableStream.end();
                writableStream.on('finish', () => {
                    const stat = fs.statSync(path);
                    const fileSize = stat.size;
                    const range = req.headers.range;
                    if (range) {
                        const parts = range.replace(/bytes=/, '').split('-');
                        const start = parseInt(parts[0], 10);
                        const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
                        const chunksize = end - start + 1;
                        const file = fs.createReadStream(path, { start, end });
                        const head = {
                            'Content-Range': `bytes ${start}-${end}/${fileSize}`,
                            'Accept-Ranges': 'bytes',
                            'Content-Length': chunksize,
                            'Content-Type': 'video/mp4',
                        };
                        res.writeHead(206, head);
                        file.on('end', () => {
                            fs.unlink(path, async (error) => {
                            });
                        });
                        file.pipe(res);
                    }
                    else {
                        const head = {
                            'Content-Length': fileSize,
                            'Content-Type': 'video/mp4',
                        };
                        res.writeHead(200, head);
                        const fileReadStream = fs.createReadStream(path);
                        fileReadStream.on('end', () => {
                        });
                        fileReadStream.pipe(res);
                    }
                });
            }
            else {
                const stat = fs.statSync(path);
                const fileSize = stat.size;
                const range = req.headers.range;
                if (range) {
                    const parts = range.replace(/bytes=/, '').split('-');
                    const start = parseInt(parts[0], 10);
                    const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
                    const chunksize = end - start + 1;
                    const file = fs.createReadStream(path, {
                        start,
                        end,
                    });
                    const head = {
                        'Content-Range': `bytes ${start}-${end}/${fileSize}`,
                        'Accept-Ranges': 'bytes',
                        'Content-Length': chunksize,
                        'Content-Type': 'video/mp4',
                    };
                    res.writeHead(206, head);
                    file.on('end', () => {
                        fs.unlink(path, async (error) => {
                            console.log(error);
                        });
                    });
                    file.pipe(res);
                }
                else {
                    const head = {
                        'Content-Length': fileSize,
                        'Content-Type': 'video/mp4',
                    };
                    res.writeHead(200, head);
                    const fileReadStream = fs.createReadStream(path);
                    fileReadStream.on('end', () => {
                        fs.unlink(path, async (error) => {
                            console.log(error);
                        });
                    });
                    fileReadStream.pipe(res);
                }
            }
        }
        catch (error) {
            console.log('play error =====', error);
        }
    }
    async getAcessFile(res, params) {
        var _a, _b;
        try {
            const { accessKey, token } = params;
            console.log('file: file.controller.ts:328 ~ FileController ~ getAcessFile ~ accessKey, token:', accessKey, token);
            const accessDataResponse = await (0, rxjs_1.firstValueFrom)(this.httpService
                .post(`${process.env.API_SERVER_URL}/file/access/verify-token`, {
                accessKey,
                token,
            })
                .pipe((0, rxjs_1.map)((response) => {
                return response.data;
            })));
            const accessData = accessDataResponse === null || accessDataResponse === void 0 ? void 0 : accessDataResponse.data;
            const ipfsMetaData = accessData.fileMetaData.sort(function (a, b) {
                return a.index - b.index;
            });
            res.set({
                'Content-Type': accessData === null || accessData === void 0 ? void 0 : accessData.fileType,
                'Content-Disposition': `filename="${accessData.fileName}"`,
            });
            const readableStream = new stream_1.Readable();
            readableStream._read = () => { };
            readableStream.pipe(res).on;
            for (let i = 0; i < ipfsMetaData.length; i++) {
                const fileRespone = await (0, rxjs_1.firstValueFrom)(this.httpService
                    .get(`http://46.101.133.110:8080/api/v0/cat/${ipfsMetaData[i].cid}`, {
                    responseType: 'arraybuffer',
                })
                    .pipe((0, rxjs_1.map)((response) => {
                    return response.data;
                })));
                const decryptedData = await decryptedSecretKeyAndFile(accessData.data, accessData.secretKey, accessData.accessKey, accessData.iv, fileRespone, accessData.salt);
                readableStream.push(Buffer.from(decryptedData));
            }
            readableStream.push(null);
        }
        catch (error) {
            console.log('error ===', ((_a = error === null || error === void 0 ? void 0 : error.response) === null || _a === void 0 ? void 0 : _a.data) || (error === null || error === void 0 ? void 0 : error.message));
            return res
                .status(common_1.HttpStatus.NOT_FOUND)
                .send(((_b = error === null || error === void 0 ? void 0 : error.response) === null || _b === void 0 ? void 0 : _b.data) || { success: false, message: error === null || error === void 0 ? void 0 : error.message });
        }
    }
    async downloadFile(res, params) {
        try {
            const { accessKey, token } = params;
            const accessDataResponse = await (0, rxjs_1.firstValueFrom)(this.httpService
                .post(`${process.env.API_SERVER_URL}/file/access/verify-token`, {
                accessKey,
                token,
            })
                .pipe((0, rxjs_1.map)((response) => {
                return response.data;
            })));
            const accessData = accessDataResponse === null || accessDataResponse === void 0 ? void 0 : accessDataResponse.data;
            const ipfsMetaData = accessData.fileMetaData.sort(function (a, b) {
                return a.index - b.index;
            });
            res.set({
                'Content-Type': 'application/octet-stream',
                'Content-Disposition': `filename="${accessData.fileName}"`,
            });
            const readableStream = new stream_1.Readable();
            readableStream._read = () => { };
            readableStream.pipe(res).on;
            for (let i = 0; i < ipfsMetaData.length; i++) {
                const fileRespone = await (0, rxjs_1.firstValueFrom)(this.httpService
                    .get(`http://46.101.133.110:8080/api/v0/cat/${ipfsMetaData[i].cid}`, {
                    responseType: 'arraybuffer',
                })
                    .pipe((0, rxjs_1.map)((response) => {
                    return response.data;
                })));
                const decryptedData = await decryptedSecretKeyAndFile(accessData.data, accessData.secretKey, accessData.accessKey, accessData.iv, fileRespone, accessData.salt);
                readableStream.push(Buffer.from(decryptedData));
            }
            readableStream.push(null);
        }
        catch (error) {
            console.error('error ===', error);
            return res.status(common_1.HttpStatus.NOT_FOUND).send();
        }
    }
};
__decorate([
    (0, common_1.Get)('node/status'),
    __param(0, (0, common_1.Res)()),
    __param(1, (0, common_1.Param)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, Object]),
    __metadata("design:returntype", Promise)
], FileController.prototype, "getStatus", null);
__decorate([
    (0, common_1.Get)('view/access-play/:accessKey/:token?'),
    __param(0, (0, common_1.Res)()),
    __param(1, (0, common_1.Param)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, Object]),
    __metadata("design:returntype", Promise)
], FileController.prototype, "playVideo", null);
__decorate([
    (0, common_1.Get)('view/access/:accessKey/:token?'),
    __param(0, (0, common_1.Res)()),
    __param(1, (0, common_1.Param)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], FileController.prototype, "getAcessFile", null);
__decorate([
    (0, common_1.Get)('download/:accessKey/:token?'),
    __param(0, (0, common_1.Res)()),
    __param(1, (0, common_1.Param)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], FileController.prototype, "downloadFile", null);
FileController = __decorate([
    (0, common_1.Controller)('api/file'),
    __metadata("design:paramtypes", [axios_1.HttpService,
        file_service_1.FileService])
], FileController);
exports.FileController = FileController;
//# sourceMappingURL=file.controller.js.map