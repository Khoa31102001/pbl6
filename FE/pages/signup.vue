<template>
  <div
    class="
      auth__container
      w-100
      h-screen
      background-pink
      d-flex
      align-items-center
    "
  >
    <div class="auth__background d-flex">
      <div class="auth__logo">
        <IconLogo @click.native="$router.push(localePath({ name: 'index' }))" />
      </div>
      <img src="@/static/shopping-woman.png" alt="shopping woman" />
    </div>
    <div class="auth__content">
      <ValidationObserver
        v-slot="{ handleSubmit, invalid }"
        ref="validator"
        class="
          auth__form
          background-white
          w-100
          h-100
          d-flex
          flex-column
          align-items-center
          justify-content-center
          shadow
        "
      >
        <div class="text-super text-center mb-4">
          {{ $t('signup.welcomeToEShopping') }}
        </div>

        <form
          v-if="!isSentEmail"
          class="form__container"
          @submit.prevent.stop="handleSubmit(signUp)"
        >
          <b-button
            pill
            block
            variant="outline-primary"
            class="d-flex align-items-center justify-content-center mb-4"
            type="button"
            @click="googleSignIn"
          >
            <img
              src="https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png"
              alt="Google logo"
              class="mr-2"
              width="24"
            />
            {{ $t('signup.signInWithGoogle') }}
          </b-button>

          <hr class="mb-4" />

          <ValidationProvider
            v-slot="{ errors, validated, passed }"
            vid="email"
            rules="required|email"
          >
            <b-form-group
              :label="$t('signup.emailAddress')"
              label-for="input-email"
              :state="validated ? passed : null"
            >
              <b-form-input
                id="input-email"
                v-model="email"
                type="email"
                :state="email !== '' ? !errors[0] : null"
                :placeholder="$t('signup.enterYourEmailAddress')"
                aria-describedby="email-error"
                trim
                autofocus
              />
              <b-form-invalid-feedback id="email-error">
                {{ $t('signup.pleaseEnterAValidEmailAddress') }}
              </b-form-invalid-feedback>
            </b-form-group>
          </ValidationProvider>

          <b-button
            pill
            block
            variant="outline-primary"
            type="submit"
            :disabled="invalid"
            class="mb-4"
          >
            {{ $t('signup.signUp') }}
          </b-button>
          <div class="text-center">
            {{ $t('signup.alreadyHaveAnAccount') }}
            <router-link :to="localeRoute({ name: 'signin' })">
              {{ $t('signup.signIn') }}
            </router-link>
          </div>
        </form>

        <div v-else class="text-center">
          <div class="text-primary text-large">
            {{ $t('signup.pleaseCheckYourEmail') }}
          </div>
          <div class="mt-2">
            {{ $t('signup.anEmailToVerifyYourAccountHasBeenSentToYou') }}
          </div>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import IconLogo from '~/components/icons/IconLogo.vue';

export default Vue.extend({
  name: 'SignUp',

  components: { IconLogo },

  layout: 'auth',

  auth: 'guest',

  data() {
    return {
      email: '',
      isLoading: false,
      isSentEmail: false,
    };
  },

  methods: {
    async signUp() {
      if (this.isLoading) return;

      try {
        this.isLoading = true;
        this.$nuxt.$loading.start();

        await this.$axios
          .$post('/auth/signup', {
            email: this.email,
          })
          .then(() => {
            this.isSentEmail = true;
          });

        this.$root.$bvToast.toast(
          this.$t('signup.signUpSuccessful') as string,
          {
            title: this.$t('toastTitle.success') as string,
            variant: 'success',
          }
        );
      } catch (error: any) {
        this.email = '';

        if (error.statusCode === 409) {
          this.$root.$bvToast.toast(
            this.$t('signup.emailAlreadyExists') as string,
            {
              title: this.$t('toastTitle.error') as string,
              variant: 'danger',
            }
          );
        } else {
          this.$root.$bvToast.toast(
            this.$t('signup.signUpUnsuccessful') as string,
            {
              title: this.$t('toastTitle.error') as string,
              variant: 'danger',
            }
          );
        }
      } finally {
        this.isLoading = false;
        this.$nuxt.$loading.finish();
      }
    },

    googleSignIn() {
      this.$nuxt.$loading.start();
      this.$auth
        .loginWith('google', { params: { prompt: 'select_account' } })
        .catch((error) => {
          this.$root.$bvToast.toast(error.message, {
            title: 'Error',
            variant: 'danger',
          });
          this.$nuxt.$loading.finish();
        });
    },
  },
});
</script>
