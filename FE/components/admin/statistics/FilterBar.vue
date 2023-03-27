<template>
  <div class="d-flex background-pink justify-content-between rounded p-3">
    <div class="d-flex align-items-center">
      <b-form-datepicker
        id="input-start-day"
        v-model="startDate"
        :max="endDate"
        :placeholder="$t('adminStatistics.filter.startDay')"
        class="mr-3"
        @input="filter"
      ></b-form-datepicker>
      <b-form-datepicker
        id="input-end-day"
        v-model="endDate"
        :min="startDate"
        :placeholder="$t('adminStatistics.filter.endDate')"
        @input="filter"
      ></b-form-datepicker>
    </div>
    <b-form-select
      v-if="hasSort"
      v-model="sort"
      plain
      :options="sorts"
      style="width: fit-content"
      @change="filter"
    ></b-form-select>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

import { Option } from '~/types/Option';

const ONE_MONTH = 30 * 24 * 60 * 60 * 1000;

export default Vue.extend({
  name: 'FilterBar',

  props: {
    hasSort: {
      type: Boolean,
      default: true,
    },
  },

  data() {
    return {
      startDate:
        this.$route.query.startDate ||
        new Date(Date.now() - ONE_MONTH).toISOString(),
      endDate: this.$route.query.endDate || new Date(Date.now()).toISOString(),
      sort: this.$route.query.sort || 'desc',
      sorts: [
        { value: 'asc', text: this.$t('sort.asc') },
        { value: 'desc', text: this.$t('sort.desc') },
      ] as Option[],
    };
  },

  methods: {
    filter() {
      this.$router.push({
        query: {
          ...this.$route.query,
          startDate: this.startDate,
          endDate: this.endDate,
          sort: this.sort,
        },
      });
    },
  },
});
</script>
