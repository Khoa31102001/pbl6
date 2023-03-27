<template>
  <div class="d-flex flex-column align-items-center">
    <div class="title mb-5">
      {{ $t('account.title') }}
    </div>
    <div class="form-section flex-fill">
      <div class="section-title">
        <div>
          {{ $t('account.personalInfo') }}
        </div>
      </div>
      <b-collapse visible>
        <div class="d-flex flex-wrap">
          <b-form-group
            :label="$t('account.email')"
            label-for="email"
            class="flex-fill"
          >
            <b-form-input
              id="email"
              readonly
              :value="$auth.user ? $auth.user.email : ''"
            ></b-form-input>
          </b-form-group>
        </div>
      </b-collapse>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'Account',

  middleware: 'auth',
});
</script>

<style lang="scss" scoped>
.form-section {
  background-color: white;
  border-radius: 10px;
  box-shadow: $box-shadow-normal;
}
</style>
