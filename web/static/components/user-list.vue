<template>
    <div id="users-list">
        <h3>Online</h3>
        <ul>
            <transition-group name="user-appear">
            <li v-for="user in users" v-bind:key="user.user">
                {{user.user}} ({{user.online_at}})
            </li>
            </transition-group>
        </ul>
    </div>
</template>
<script>
export default {
   props: ['users']
}
</script>
<style lang="sass">
#users-list {
    background-color: #363c40;
    width: 250px;
    float: left;
    height: 100vh;
    h3 {
        font-size: 0.9em;
        margin-left: 10px;
        color: rgba(255, 255, 255, 0.7);
    }
    ul {
        list-style: none;
        padding-left: 20px;
        color: rgba(255, 255, 255, 0.9);
        li {
            &.user-appear-enter-active, &.user-appear-leave-active {
                transition: all .2s
            }
            &.user-appear-enter, &.user-appear-leave-active {
                opacity: 0;
                transform: translateX(-15px);
            }
        }
    }
}
</style>
