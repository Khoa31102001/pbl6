<template>
  <div class="d-flex flex-column">
    <div class="text-super font-weight-bold">
      {{ $t('adminStatistics.title') }}
    </div>
    <div class="mt-2">{{ $t('adminStatistics.subtitle') }}</div>
    <div class="d-flex flex-wrap mt-4" style="gap: 24px">
      <TopSaleProduct
        :top-sale-products="topSaleProducts"
        style="min-width: 400px"
      />
      <Revenue
        :total-expense="totalExpense"
        :total-income="totalIncome"
        :revenue="revenue"
        style="min-width: 400px"
      />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { Context } from '@nuxt/types';

import TopSaleProduct from '~/components/admin/statistics/TopSaleProduct.vue';
import Revenue from '~/components/admin/statistics/Revenue.vue';
import { SaleProduct } from '~/types/Statistic';

export default Vue.extend({
  name: 'AdminDashboard',

  components: { TopSaleProduct, Revenue },

  layout: 'dashboard',

  middleware: 'auth',

  async asyncData(ctx: Context) {
    try {
      const { query } = ctx.route;
      const params = {
        sort: query.sort || 'desc',
        startDate: query.startDate || '',
        endDate: query.endDate || '',
        limit: query.limit ? Number(query.limit) : 5,
      };
      const { data: topSaleProducts } = await ctx.$axios.$get(
        '/statistics/top-sale-product',
        { params }
      );
      const {
        data: { totalExpense, totalIncome, revenue },
      } = await ctx.$axios.$get('/statistics/revenue', { params });
      return { topSaleProducts, totalExpense, totalIncome, revenue };
    } catch (error) {
      return {};
    }
  },

  data() {
    return {
      topSaleProducts: [] as SaleProduct[],
      totalExpense: 0,
      totalIncome: 0,
      revenue: 0,
    };
  },
});
</script>
