import { HttpService } from '@nestjs/axios';
import type { Response } from 'express';
import { FileService } from './file.service';
export declare class FileController {
    private readonly httpService;
    private readonly fileService;
    constructor(httpService: HttpService, fileService: FileService);
    getStatus(res: Response, _params: any, _req: any): Promise<Response<any, Record<string, any>>>;
    playVideo(res: Response, params: any, req: any): Promise<void>;
    getAcessFile(res: Response, params: any): Promise<Response<any, Record<string, any>>>;
    downloadFile(res: Response, params: any): Promise<Response<any, Record<string, any>>>;
}
