"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const file_module_1 = require("./file.module");
async function bootstrap() {
    const app = await core_1.NestFactory.create(file_module_1.AppModule);
    await app.listen(process.env.APP_PORT || 3008);
}
bootstrap();
//# sourceMappingURL=main.js.map