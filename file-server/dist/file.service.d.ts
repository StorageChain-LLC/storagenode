import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
export declare class FileService {
    private readonly httpService;
    private readonly jwtService;
    constructor(httpService: HttpService, jwtService: JwtService);
    getHello(): string;
    getIpAddress(): any[];
    getIpfsId(): Promise<any>;
    getClusterId(): Promise<any>;
    saveNodeOsDetails(): Promise<{
        success: boolean;
        message: any;
    }>;
}
