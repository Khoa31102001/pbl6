<template>
  <div class="form-section border-primary shadow">
    <div class="section-title">
      {{ $t('adminStatistics.topSaleProduct') }}
    </div>
    <div class="section-content border-primary">
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
    <div class="section-content text-right border-primary">
      <nuxt-link :to="localePath({ name: 'admin-statistics-sale' })">{{
        $t('adminStatistics.viewFullReport')
      }}</nuxt-link>
    </div>
  </div>
</template>

<script lang="ts">
import Vue, { PropType } from 'vue';

import { SaleProduct } from '~/types/Statistic';

export default Vue.extend({
  name: 'TopSaleProduct',

  props: {
    topSaleProducts: {
      type: Array as PropType<SaleProduct[]>,
      default: () => [],
    },
  },

  computed: {
    maxQuantity(): number {
      return Math.max(...this.topSaleProducts.map((item) => item.quantity));
    },
  },
});
</script>
