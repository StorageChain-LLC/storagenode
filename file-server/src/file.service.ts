import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';

import * as os from 'os';
import { firstValueFrom, map } from 'rxjs';

// Uncomment this only for LocalHost
// process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';

@Injectable()
export class FileService {
  constructor(private readonly httpService: HttpService) {}

  getHello(): string {
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
      const ipfsNodeInformation = await firstValueFrom(
        this.httpService
          .post('http://localhost:5001/api/v0/id')
          .pipe(map((response) => response.data)),
      );
      return ipfsNodeInformation;
    } catch (err) {
      console.error(
        'file: file.service.ts:37 ~ AppService ~ getIpfsId ~ err:',
        err?.message,
      );
      return null;
    }
  }

  async getClusterId() {
    try {
      const ipfsClusterResponse = await firstValueFrom(
        this.httpService
          //TODO: Replace this cluster URL with http://localhost:port
          // .get('http://46.101.133.110:9094/id')
          .get('http://localhost:9094/id')
          .pipe(map((response) => response?.data)),
      );
      return ipfsClusterResponse;
    } catch (err) {
      console.error(
        'file: file.service.ts:56 ~ AppService ~ getClusterId ~ err:',
        err?.message,
      );
      return null;
    }
  }

  async updateNodeDetailsOnRecursiveCall(
    ipAddress: string,
    ipfsClusterId: string,
    ipfsId: string,
  ) {
    try {
      const updateNodeDetails = await firstValueFrom(
        this.httpService
          .post(`${process.env.API_SERVER_URL}/node/update-node-details`, {
            ipAddress,
            ipfsClusterId,
            ipfsId,
          })
          .pipe(map((response) => response?.data)),
      );

      console.log(
        'file: file.service.ts:111 ~ FileService ~ saveNodeOsDetails ~ addNodeResponse:',
        updateNodeDetails,
      );
    } catch (err) {
      console.error(
        'file: file.service.ts:97 ~ FileService ~ err:',
        err?.response?.data?.message || err?.message,
      );

      setTimeout(async () => await this.saveNodeOsDetails(), 5000);
    }
  }

  async saveNodeOsDetails() {
    try {
      // IP Address
      const ipAddresses = this.getIpAddress();
      console.log(
        'file: file.service.ts:76 ~ FileService ~ saveNodeOsDetails ~ ipAddresses:',
        ipAddresses,
      );

      // Check node details already updated or not
      const nodeDetailsResponse = await firstValueFrom(
        this.httpService
          .get(
            `${process.env.API_SERVER_URL}/node/node-details/${ipAddresses[0]}`,
          )
          .pipe(map((response) => response?.data)),
      );

      if (nodeDetailsResponse?.data?.ipfsClusterId) {
        return {
          success: true,
          message: 'Node details are already updated',
        };
      }

      // IPFS ID
      const ipfsId = await this.getIpfsId();
      console.log(
        'file: file.service.ts:75 ~ FileService ~ saveNodeOsDetails ~ ipfsId:',
        ipfsId?.ID,
      );

      // IPFS Cluster Id
      const ipfsClusterId = await this.getClusterId();
      console.log(
        'file: file.service.ts:86 ~ FileService ~ saveNodeOsDetails ~ ipfsClusterId:',
        ipfsClusterId?.id,
      );

      await this.updateNodeDetailsOnRecursiveCall(
        ipAddresses[0],
        ipfsClusterId?.id,
        ipfsId?.ID,
      );
    } catch (err) {
      console.error(
        'file: file.service.ts:14 ~ AppService ~ saveNodeOsDetails ~ err:',
        err?.response?.data?.message || err?.message,
      );
      return {
        success: false,
        message: err?.response?.data?.message || err?.message,
      };
    }
  }
}
