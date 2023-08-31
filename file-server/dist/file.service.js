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
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileService = void 0;
const axios_1 = require("@nestjs/axios");
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const fs = require("fs");
const os = require("os");
const rxjs_1 = require("rxjs");
process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';
let FileService = class FileService {
    constructor(httpService, jwtService) {
        this.httpService = httpService;
        this.jwtService = jwtService;
    }
    getHello() {
        return 'Hello World!';
    }
    getIpAddress() {
        const interfaces = os.networkInterfaces();
        const addresses = [];
        for (const interfaceName of Object.keys(interfaces)) {
            for (const iface of interfaces[interfaceName]) {
                if (iface.family === 'IPv4' && !iface.internal) {
                    addresses.push(iface.address);
                }
            }
        }
        return addresses;
    }
    async getIpfsId() {
        try {
            const ipfsNodeInformation = await (0, rxjs_1.firstValueFrom)(this.httpService
                .post('http://localhost:5001/api/v0/id')
                .pipe((0, rxjs_1.map)((response) => response.data)));
            return ipfsNodeInformation;
        }
        catch (err) {
            console.error('file: file.service.ts:37 ~ AppService ~ getIpfsId ~ err:', err);
            return null;
        }
    }
    async getClusterId() {
        const env = process.env.ENV || 'development';
        try {
            const ipfsClusterResponse = await (0, rxjs_1.firstValueFrom)(this.httpService
                .get(env === 'development'
                ? 'http://localhost:9094/id'
                : 'http://cluster-internal.io:9094/id')
                .pipe((0, rxjs_1.map)((response) => response === null || response === void 0 ? void 0 : response.data)));
            console.warn('Status URL: ' + env === 'development'
                ? 'http://localhost:9094/id'
                : 'http://cluster-internal.io:9094/id');
            return ipfsClusterResponse;
        }
        catch (err) {
            console.error('file: file.service.ts:56 ~ AppService ~ getClusterId ~ err:', err);
            return null;
        }
    }
    async saveNodeOsDetails() {
        try {
            const ipAddresses = this.getIpAddress();
            console.log('file: file.service.ts:76 ~ FileService ~ saveNodeOsDetails ~ ipAddresses:', ipAddresses);
            const ipfsId = await this.getIpfsId();
            console.log('file: file.service.ts:75 ~ FileService ~ saveNodeOsDetails ~ ipfsId:', ipfsId === null || ipfsId === void 0 ? void 0 : ipfsId.ID);
            const ipfsClusterId = await this.getClusterId();
            console.log('file: file.service.ts:86 ~ FileService ~ saveNodeOsDetails ~ ipfsClusterId:', ipfsClusterId === null || ipfsClusterId === void 0 ? void 0 : ipfsClusterId.id);
            const systemName = os.hostname();
            console.log('file: file.service.ts:95 ~ FileService ~ saveNodeOsDetails ~ systemName:', systemName);
            const addNodeResponse = await (0, rxjs_1.firstValueFrom)(this.httpService
                .post(`${process.env.API_SERVER_URL}/node/os-info`, {
                ipAddress: ipAddresses[0],
                name: systemName,
                ipfsClusterId: ipfsClusterId === null || ipfsClusterId === void 0 ? void 0 : ipfsClusterId.id,
                ipfsId: ipfsId === null || ipfsId === void 0 ? void 0 : ipfsId.ID,
                totalStorage: parseInt(process.env.TOTAL_STORAGE),
            })
                .pipe((0, rxjs_1.map)((response) => response === null || response === void 0 ? void 0 : response.data)));
            console.log('file: file.service.ts:111 ~ FileService ~ saveNodeOsDetails ~ addNodeResponse:', addNodeResponse);
            if (addNodeResponse === null || addNodeResponse === void 0 ? void 0 : addNodeResponse.success) {
                const authToken = this.jwtService.sign(addNodeResponse === null || addNodeResponse === void 0 ? void 0 : addNodeResponse.data);
                fs.writeFileSync('src/config/node-config.json', JSON.stringify(Object.assign({ authToken }, addNodeResponse === null || addNodeResponse === void 0 ? void 0 : addNodeResponse.data)), 'utf8');
            }
        }
        catch (err) {
            console.error('file: file.service.ts:14 ~ AppService ~ saveNodeOsDetails ~ err:', err === null || err === void 0 ? void 0 : err.message);
            return {
                success: false,
                message: err.message,
            };
        }
    }
};
FileService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [axios_1.HttpService,
        jwt_1.JwtService])
], FileService);
exports.FileService = FileService;
//# sourceMappingURL=file.service.js.map