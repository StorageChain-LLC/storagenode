import type { Response } from 'express';
import { FileService } from './file.service';
export declare class ClusterController {
    private readonly fileService;
    constructor(fileService: FileService);
    getStatus(res: Response, _params: any, _req: any): Promise<Response<any, Record<string, any>>>;
}
