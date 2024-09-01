

# vue3

## vue 响应式的本质

`函数和数据的关联`

## Vue3的生命周期方法有哪些？

Vue3的生命周期方法包括：
beforeCreate：在实例初始化之后，数据观测和事件配置之前调用。
created：在实例创建完成后立即调用，此时实例已完成数据观测、属性和方法的运算，但尚未挂载到DOM，$el属性目前不可见。
beforeMount：在挂载开始之前被调用：相关的render函数首次被调用。
mounted：el被新创建的vm.$el替换，并挂载到实例上去之后调用该钩子。
beforeUpdate：数据更新时调用，发生在虚拟DOM打补丁之前。

## vue3 父子组件传参

父组件向子组件传参，通过props属性，子组件通过props接收父组件传递过来的参数。

子组件向父组件传参，通过$emit方法，子组件通过$emit方法触发一个事件，父组件通过v-on监听子组件触发的事件，从而接收子组件传递过来的参数。

在 Vue 3 中，父子组件之间传递参数可以通过 props 和 emit 来实现。以下是一个简单的示例，展示了如何从父组件向子组件传递参数，以及如何从子组件向父组件传递事件。

父组件向子组件传递参数
父组件（ParentComponent.vue）：
```vue
<template>
  <div>
    <h1>父组件</h1>
    <ChildComponent :message="parentMessage" @childEvent="handleChildEvent" />
  </div>
</template>

<script>
import ChildComponent from './ChildComponent.vue';

export default {
  components: {
    ChildComponent
  },
  data() {
    return {
      parentMessage: 'Hello from Parent'
    };
  },
  methods: {
    handleChildEvent(eventData) {
      console.log('Received event from child:', eventData);
    }
  }
};
</script>

```


子组件（ChildComponent.vue）：
```vue
<template>
  <div>
    <h2>子组件</h2>
    <p>{{ message }}</p>
    <button @click="sendEventToParent">发送事件到父组件</button>
  </div>
</template>

<script>
export default {
  props: {
    message: {
      type: String,
      required: true
    }
  },
  methods: {
    sendEventToParent() {
      this.$emit('childEvent', 'Hello from Child');
    }
  }
};
</script>

```


子组件向父组件传递事件
在上面的示例中，子组件通过 this.$emit 方法向父组件发送了一个自定义事件 childEvent，并传递了一个字符串参数 'Hello from Child'。父组件通过监听这个事件，并在 handleChildEvent 方法中处理接收到的数据。

总结
父组件通过 props 向子组件传递数据。
子组件通过 this.$emit 向父组件发送自定义事件，并可以传递参数。
父组件通过监听子组件发送的事件来处理相应的逻辑。
通过这种方式，Vue 3 中的父子组件可以方便地进行双向通信。

## vue3组件间的通信方式

Vue 3 提供了多种组件间通信的方式，包括以下几种：

1. Props 父传子：父组件向子组件传递数据。
2. Events 子传父：子组件向父组件发送事件，并可以传递参数。
3. Provide/Inject 依赖注入：祖先组件向后代组件传递数据，而不需要通过 props 逐层传递。
4. Vuex：状态管理库，用于在多个组件间共享状态。
5. Event Bus：创建一个事件总线，用于在任意组件间通信。
6. Slots 插槽：父组件向子组件传递模板内容。

7.双向绑定v-model
在 Vue 3 中，可以使用 v-model 指令来实现双向绑定。v-model 指令可以在父组件和子组件之间建立双向绑定，使得父组件和子组件的数据可以自动同步。

下面是一个使用 v-model 的示例：

父组件（ParentComponent.vue）：
```vue
<template>
  <div>
    <h2>父组件</h2>
    <input v-model="message" />
    <ChildComponent v-model="message" />
  </div>
</template>

<script>
import ChildComponent from './ChildComponent.vue';

export default {
  components: {
    ChildComponent
  },
  data() {
    return {
      message: ''
    };
  }
};
</script>

```


子组件（ChildComponent.vue）：
```vue
<template>
  <div>子组件：{{ message }}</div>
</template>

<script>
export default {
  props: {
    modelValue: {
      type: String,
      required: true
    }
  },
  computed: {
    message: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      }
    }
  }
};
</script>

```



## vue3中如何使用provide/inject

在 Vue 3 中，可以使用 provide 和 inject 来实现祖先组件向后代组件传递数据，而不需要通过 props 逐层传递。

provide：祖先组件使用 provide 方法来提供数据，可以提供任何类型的数据，包括对象、数组、函数等。

inject：后代组件使用 inject 方法来注入祖先组件提供的数据，可以注入任何类型的数据，包括对象、数组、函数等。

下面是一个使用 provide 和 inject 的示例：

祖先组件（AncestorComponent.vue）：
```vue
<template>
  <div>Ancestor Component</div>
  <ChildComponent />
</template>

<script>
import ChildComponent from './ChildComponent.vue';

export default {
  components: {
    ChildComponent
  },
  provide() {
    return {
      message: 'Hello from Ancestor Component'
    };
  }
};
</script>
```

后代组件（ChildComponent.vue）：
```vue
<template>
  <div>Child Component</div>
  <GrandchildComponent />
</template>

<script>
import GrandchildComponent from './GrandchildComponent.vue';

export default {
  components: {
    GrandchildComponent
  },
  inject: ['message']
};
</script>
```

后代组件（GrandchildComponent.vue）：
```vue
<template>
  <div>Grandchild Component</div>
  <p>{{ message }}</p>
</template>

<script>
export default {
  inject: ['message']
};
</script>
```

在上面的示例中，祖先组件使用 provide 方法提供了一个名为 message 的数据，后代组件使用 inject 方法注入了这个数据，并在模板中显示出来。

需要注意的是，`provide 和 inject 只能在组件树中使用，不能在普通的 JavaScript 代码中使用`。
