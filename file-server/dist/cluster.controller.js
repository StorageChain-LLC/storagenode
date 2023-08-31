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
exports.ClusterController = void 0;
const common_1 = require("@nestjs/common");
const file_service_1 = require("./file.service");
let ClusterController = class ClusterController {
    constructor(fileService) {
        this.fileService = fileService;
        this.fileService.saveNodeOsDetails();
    }
    async getStatus(res, _params, _req) {
        const cluster = await this.fileService.getClusterId();
        const clusterId = (cluster === null || cluster === void 0 ? void 0 : cluster.addresses[cluster.addresses.length - 1]) || null;
        return res.send({ isClusterOnline: !!clusterId });
    }
};
__decorate([
    (0, common_1.Get)('status'),
    __param(0, (0, common_1.Res)()),
    __param(1, (0, common_1.Param)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, Object]),
    __metadata("design:returntype", Promise)
], ClusterController.prototype, "getStatus", null);
ClusterController = __decorate([
    (0, common_1.Controller)('api/cluster'),
    __metadata("design:paramtypes", [file_service_1.FileService])
], ClusterController);
exports.ClusterController = ClusterController;
//# sourceMappingURL=cluster.controller.js.map