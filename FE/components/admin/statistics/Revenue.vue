<template>
  <div class="form-section border-primary shadow">
    <div class="section-title">
      {{ $t('adminStatistics.lastMonthRevenue') }}
    </div>
    <div class="section-content border-primary">
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
    <div class="section-content text-right border-primary">
      <nuxt-link :to="localePath({ name: 'admin-statistics-revenue' })">{{
        $t('adminStatistics.viewFullReport')
      }}</nuxt-link>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import IconIncome from '~/components/icons/IconIncome.vue';
import IconExpense from '~/components/icons/IconExpense.vue';
import IconMoneyBag from '~/components/icons/IconMoneyBag.vue';
import formatPrice from '~/utils/formatPrice';

export default Vue.extend({
  name: 'Revenue',

  components: { IconIncome, IconExpense, IconMoneyBag },

  props: {
    totalExpense: {
      type: Number,
      default: 0,
    },

    totalIncome: {
      type: Number,
      default: 0,
    },

    revenue: {
      type: Number,
      default: 0,
    },
  },

  methods: {
    formatPrice,
  },
});
</script>
