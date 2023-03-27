<template>
  <div class="d-flex flex-column">
    <div class="text-super font-weight-bold">
      {{ $t('adminStatistics.revenue.title') }}
    </div>
    <div class="mt-2">{{ $t('adminStatistics.revenue.subtitle') }}</div>
    <FilterBar class="mt-4" :has-sort="false" />
    <div class="d-flex flex-column mt-4">
      <div
        class="d-flex align-items-center border border-primary rounded p-3 mb-2"
      >
        <IconIncome />
        <div class="ml-3">
          <div class="text-large font-weight-bold">
            {{ formatPrice(totalIncome) }}
          </div>
          <div>{{ $t('adminStatistics.revenue.totalIncome') }}</div>
        </div>
      </div>
      <div
        class="d-flex align-items-center border border-primary rounded p-3 mb-2"
      >
        <IconExpense />
        <div class="ml-3">
          <div class="text-large font-weight-bold">
            {{ formatPrice(totalExpense) }}
          </div>
          <div>{{ $t('adminStatistics.revenue.totalExpense') }}</div>
        </div>
      </div>
      <div
        class="d-flex align-items-center border border-primary rounded p-3 mb-2"
      >
        <IconMoneyBag />
        <div class="ml-3">
          <div class="text-large font-weight-bold">
            {{ formatPrice(revenue) }}
          </div>
          <div>{{ $t('adminStatistics.revenue.totalRevenue') }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { Context } from '@nuxt/types';

import FilterBar from '~/components/admin/statistics/FilterBar.vue';
import IconIncome from '~/components/icons/IconIncome.vue';
import IconExpense from '~/components/icons/IconExpense.vue';
import IconMoneyBag from '~/components/icons/IconMoneyBag.vue';
import formatPrice from '~/utils/formatPrice';

const ONE_MONTH = 30 * 24 * 60 * 60 * 1000;

export default Vue.extend({
  name: 'AdminRevenue',

  components: { FilterBar, IconIncome, IconExpense, IconMoneyBag },

  layout: 'dashboard',

  middleware: 'auth',

  async asyncData(ctx: Context) {
    try {
      const { query } = ctx.route;
      const params = {
        startDate: query.startDate || new Date(Date.now() - ONE_MONTH),
        endDate: query.endDate || new Date(Date.now()),
      };
      const {
        data: { totalExpense, totalIncome, revenue },
      } = await ctx.$axios.$get('/statistics/revenue', { params });
      return { totalExpense, totalIncome, revenue };
    } catch (error) {
      return {};
    }
  },

  data() {
    return {
      totalExpense: 0,
      totalIncome: 0,
      revenue: 0,
    };
  },

  watchQuery: ['startDate', 'endDate'],

  methods: {
    formatPrice,
  },
});
</script>
