<template>
  <b-table
    hover
    borderless
    responsive
    thead-class="background-pink"
    :fields="fields"
    :items="discounts"
    @row-clicked="
      $router.push(
        localePath({ name: 'admin-discounts-id', params: { id: $event.id } })
      )
    "
  >
    <template #cell(percent)="data"> {{ data.value }}% </template>
    <template #cell(action)="data">
      <IconPencil
        @click.native.stop="
          $router.push(
            localePath({
              name: 'admin-discounts-id-edit',
              params: { id: data.item.id },
            })
          )
        "
      />
      <IconTrash
        v-b-modal.modal-delete-discount
        class="ml-3"
        @click.native="$emit('deleting-discount-id', data.item.id)"
      />
    </template>
  </b-table>
</template>

<script lang="ts">
import Vue, { PropType } from 'vue';
import IconPencil from '~/components/icons/IconPencil.vue';
import IconTrash from '~/components/icons/IconTrash.vue';
import { Discount } from '~/types/Discount';
import formatDateTime from '~/utils/formatDateTime';

export default Vue.extend({
  name: 'DiscountList',

  components: {
    IconPencil,
    IconTrash,
  },

  props: {
    discounts: {
      type: Array as PropType<Discount[]>,
      default: () => [],
    },
  },

  data() {
    return {
      fields: [
        {
          key: 'name',
          label: this.$t('adminDiscounts.table.discount'),
        },
        {
          key: 'percent',
          label: this.$t('adminDiscounts.table.percent'),
        },
        {
          key: 'startDate',
          label: this.$t('adminDiscounts.table.fromTime'),
          formatter: (value: string) => formatDateTime(value),
        },
        {
          key: 'endDate',
          label: this.$t('adminDiscounts.table.toTime'),
          formatter: (value: string) => formatDateTime(value),
        },
        {
          key: 'action',
          label: this.$t('adminDiscounts.table.action'),
        },
      ],
    };
  },
});
</script>
