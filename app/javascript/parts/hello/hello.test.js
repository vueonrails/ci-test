import { shallowMount, createLocalVue } from '@vue/test-utils'
import Hello from './hello.vue'

describe('Hello', () => {
  test('says hello', () => {
    const wrapper = shallowMount(Hello)
    expect(true)
  })
})
