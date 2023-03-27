<template>
  <b-form-select
    v-model="limit"
    plain
    :options="limits"
    @change="changeLimit"
  ></b-form-select>
</template>

<script lang="ts">
import Vue from 'vue';
import { Option } from '~/types/Option';

export default Vue.extend({
  name: 'LimitBar',

  data() {
    return {
      limit: this.$route.query.limit || 10,
      limits: [
        { value: 10, text: this.$t('pagination.tenItems') },
        { value: 20, text: this.$t('pagination.twentyItems') },
        { value: 30, text: this.$t('pagination.thirtyItems') },
      ] as Option[],
    };
  },

  methods: {
    changeLimit() {
      this.$router.push({
        query: {
          ...this.$route.query,
          limit: this.limit as string,
        },
      });
    },
  },
});
</script>
