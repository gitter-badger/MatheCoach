<template lang="jade">
.content-box.separated.flex(@click="goToPage")
  .left
    info-avatar.avatar(
      v-bind:user="student"
      v-bind:size="40"
    )
    .middle
      h1.heading {{name}}
      p.text {{timeAgo}}
  .plot
    user-bar-plot.right(v-bind:user="student")

</template>

<script lang="coffee">
import InfoAvatar from "./InfoAvatar.vue"
import UserBarPlot from "./UserBarPlot.vue"
import {UserStatistics} from "/imports/api/userStatistics.coffee"
return
  computed :
    timeAgo : ->
      @$store.state.tickle.tick
      if @student.lastActive then moment(@student.lastActive).fromNow() else ""
    name : ->
      if @student.profile?.firstName? and @student.profile?.lastName?
        "#{@student.profile?.firstName} #{@student.profile?.lastName} (#{@student.username})"
      else
        "(#{@student.username})"
  methods :
    goToPage : -> @$router.push
      name : "studentResultsPage"
      params :
        id : @student._id
  props :
    student :
      type : Object
      required : true
  components : { InfoAvatar, UserBarPlot }
</script>

<style scoped lang="sass">
.flex
  display: flex
  justify-content: space-between
  align-items: center
.left
  margin-right: 15px
  display: flex
  align-items: center
.avatar
  flex-shrink: 0
.middle
  margin-left: 20px
.plot
  flex-grow: 0
  flex-shrink: 0
  width : 100px
  height : 50px
  background-color: #f0f0ff
  border-radius: 3px
  overflow: hidden
  box-shadow: 2px 2px 3px silver
</style>
