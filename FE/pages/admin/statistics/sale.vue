<template>
  <div class="d-flex flex-column">
    <div class="text-super font-weight-bold">
      {{ $t('adminStatistics.sale.title') }}
    </div>
    <div class="mt-2">{{ $t('adminStatistics.sale.subtitle') }}</div>
    <FilterBar class="mt-4" />
    <div class="d-flex flex-column mt-4">
      <div
        v-for="item in topSaleProducts"
        :key="item.product.id"
        class="d-flex align-items-center mb-2"
      >
        <img
          :src="
            item.product.images
              ? item.product.images[0].url
              : 'https://www.democraciacristajovem.org.br/wp-content/themes/dc_jovem2022/assets/images/default.jpg'
          "
          alt="eShopping image"
          width="50"
          height="50"
          class="rounded object-fit-cover"
        />
        <div class="flex-fill d-flex flex-column justify-content-between ml-2">
          <div class="font-weight-bold">
            {{ item.product.name }}
          </div>
          <b-progress :max="maxQuantity" animated class="w-100"
            ><b-progress-bar
              :value="item.quantity"
              :label="item.quantity.toString()"
            ></b-progress-bar>
          </b-progress>
        </div>
      </div>
    </div>
    <LimitBar class="w-25 mt-4" />
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { Context } from '@nuxt/types';

import LimitBar from '~/components/admin/common/LimitBar.vue';
import FilterBar from '~/components/admin/statistics/FilterBar.vue';
import { SaleProduct } from '~/types/Statistic';

const ONE_MONTH = 30 * 24 * 60 * 60 * 1000;

export default Vue.extend({
  name: 'AdminSale',

  components: { LimitBar, FilterBar },

  layout: 'dashboard',

  middleware: 'auth',

  async asyncData(ctx: Context) {
    try {
      const { query } = ctx.route;
      const params = {
        sort: query.sort || 'desc',
        startDate: query.startDate || new Date(Date.now() - ONE_MONTH),
        endDate: query.endDate || new Date(Date.now()),
        limit: query.limit ? Number(query.limit) : 10,
      };
      const { data: topSaleProducts } = await ctx.$axios.$get(
        '/statistics/top-sale-product',
        { params }
      );
      return { topSaleProducts };
    } catch (error) {
      return {};
    }
  },

  data() {
    return {
      topSaleProducts: [] as SaleProduct[],
    };
  },

  computed: {
    maxQuantity(): number {
      return Math.max(...this.topSaleProducts.map((item) => item.quantity));
    },
  },

  watchQuery: ['startDate', 'endDate', 'limit', 'sort'],
});
</script>
