import {
  CacheInterceptor,
  CacheTTL,
  Controller,
  DefaultValuePipe,
  Get,
  HttpCode,
  HttpStatus,
  ParseIntPipe,
  Query,
  UseInterceptors,
} from '@nestjs/common';
import { ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { StatisticService } from './statistic.service';
import { ValidHttpResponse } from '@core/response/validHttp.response';
import { AuthorizeGuard } from '@app/auth/guard/roles.decorator';
import { USER_ROLE } from 'src/common/enums';

@ApiTags('statistics')
@Controller('statistics')
export class StatisticController {
  constructor(public statisticService: StatisticService) {}

  @Get('top-sale-product')
  @AuthorizeGuard([USER_ROLE.ADMIN])
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    tags: ['Statistics'],
    summary: 'Get statistics',
  })
  @ApiQuery({
    name: 'sort',
    required: false,
    type: String,
    description: 'asc or desc',
    example: 'asc',
  })
  @ApiQuery({
    name: 'startDate',
    required: false,
    type: Date,
    description: 'default first day of month',
  })
  @ApiQuery({
    name: 'endDate',
    required: false,
    type: Date,
    description: 'default today',
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'default 10',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get Top Sale Product',
  })
  async topSaleProduct(
    @Query('sort') sort: string,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('limit', new DefaultValuePipe(10), ParseIntPipe) limit: number,
  ) {
    const data = await this.statisticService.getTopSaleProduct(
      sort,
      startDate,
      endDate,
      limit,
    );
    return ValidHttpResponse.toOkResponse(data);
  }

  @Get('revenue')
  @AuthorizeGuard([USER_ROLE.ADMIN])
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    tags: ['Statistics'],
    summary: 'Get statistics',
  })
  @ApiQuery({
    name: 'startDate',
    required: false,
    type: Date,
    description: 'default first day of month',
  })
  @ApiQuery({
    name: 'endDate',
    required: false,
    type: Date,
    description: 'default today',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get Revenue',
  })
  async getRevenue(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    const data = await this.statisticService.getRevenue(startDate, endDate);
    return ValidHttpResponse.toOkResponse(data);
  }

  @Get('income-detail')
  @UseInterceptors(CacheInterceptor)
  @AuthorizeGuard([USER_ROLE.ADMIN])
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    tags: ['Statistics'],
    summary: 'Get statistics',
  })
  @ApiQuery({
    name: 'startDate',
    required: false,
    type: Date,
    description: 'default first day of month',
  })
  @ApiQuery({
    name: 'endDate',
    required: false,
    type: Date,
    description: 'default today',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Get Revenue detail',
  })
  async getIncomeDetail(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    const data = await this.statisticService.getIncomeByCategory(
      startDate,
      endDate,
    );
    return ValidHttpResponse.toOkResponse(data);
  }
}
