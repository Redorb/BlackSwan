<template>
  <div class="black-swan">
    <div class="login" v-if="enterName">
      <h1>Black Swan</h1>
      <div id="user-details">
        <md-input-container>
          <label>Please enter your name</label>
          <md-input class="username-input" type="text" v-model="username">
        </md-input-container>

        <md-button class="md-raised" v-on:click="connectToChat">Next</button>
      </div>
    </div>
    <div class="messages" v-else>
      <user-list v-bind:users="users"></user-list>
      <messages v-bind:messages="messages"></messages>
      <div id="your-message">
        <input type="text" placeholder="What do you have to say?" v-model="message" v-on:keyup.13="sendMessage">
      </div>
    </div>
  </div>
</template>

<script>
import {Socket, Presence} from "phoenix"
import Messages from "./messages.vue"
import UserList from "./user-list.vue"

export default {
  data() {
    return {
      socket: null,
      channel: null,
      messages: [],
      message: "",
      username: "",
      users: [],
      enterName: true
    }
  },
  components: {
    'messages': Messages,
    'user-list': UserList
  },
  methods: {
    sendMessage() {
      this.channel.push("new_msg", { body: this.message });
      this.message = '';
    },
    connectToChat() {
      let presences = {};
      this.enterName = false;
      this.socket = new Socket("/socket", {params: {username: this.username}});
      this.socket.connect();

      this.channel = this.socket.channel("room:lobby", {});
      this.channel.on("new_msg", payload => {
          payload.received_at = new Date(payload.received_at*1000).toLocaleString();
          this.messages.push(payload);
      });

      this.channel.on("presence_state", state => {
        presences = Presence.syncState(presences, state);
        this.assignUsers(presences);
      });

      this.channel.on("presence_diff", diff => {
        presences = Presence.syncDiff(presences, diff);
        this.assignUsers(presences);
      });
 
      this.channel.join()
        .receive("ok", response => { console.log("Joined successfully", response) })
        .receive("error", response => { console.log("Unable to join", response) });
      },
    assignUsers(presences) {
      let formatTimestamp = (timestamp) => {
        timestamp = parseInt(timestamp);
        let date = new Date(timestamp);
        return date.toLocaleTimeString();
      }
      this.users = Presence.list(presences, (user, {metas: metas}) => {
        return { user: user, online_at: formatTimestamp(metas[0].online_at) }
      })
    },
    connectToWebRTC() {
      if(!Peer.WEBRTC_SUPPORT) {
        return;
      }

      channel = socket.channel("users:lobby", {})
      channel.join()
        .receive("ok", resp => { console.log("Joined users successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

      channel.on(`chat_start`, payload => {
        if(payload.users.includes(window.username)) {
          let otherUser = payload.users.filter((id) => window.username != id)[0]
          channel.leave()
          channel = null
          let callChannel = socket.channel(payload.room)
          callChannel.join()
            .receive("ok", resp => { console.log("Joined  callChannel successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })

          getUserMedia({video: true, audio: true}, (err, stream) => {
            if(err) {
              connectToWebRTC();
              return
            }

            let myVideo = document.getElementById('my-video')
            let video = document.getElementById('caller-video')
            let vendorURL = window.URL || window.webkitURL
            myVideo.src = vendorURL ? vendorURL.createObjectURL(stream) : stream
            myVideo.muted = true
            myVideo.play()

            var peer = new Peer({ initiator: payload.initiator == window.username, trickle: true, stream: stream, config: {iceServers: [{urls:'stun:stun.l.google.com:19302'}, {urls:'stun:stun1.l.google.com:19302'}, {urls:'stun:stun2.l.google.com:19302'}, {urls:'stun:stun3.l.google.com:19302'}, {urls:'stun:stun4.l.google.com:19302'}]}})

            peer.on('error', err => {
              try {
                callChannel.leave()
                callChannel = null
                peer = null
                myVideo.removeAttribute("src");
                myVideo.load();
                video.removeAttribute("src");
                video.load();
                peer.destroy()
                connectToWebRTC()
              } catch(err) {
                //Ignore
              }
            })

            peer.on('close', () => {
              try {

                callChannel.leave()
                callChannel = null
                peer = null
                myVideo.removeAttribute("src");
                myVideo.load();
                video.removeAttribute("src");
                video.load();

                video.src = null
                connectToWebRTC()
              } catch(err) {
                //Ignore
              }
            })

            peer.on('signal', signal => { callChannel.push('signal', signal) })
            callChannel.on(`signal:${otherUser}`, signal => { peer.signal(signal) })
            peer.on('connect', () => console.log("CONNECT"))
            peer.on('stream', (callerStream) => {
              // got remote video stream, now let's show it in a video tag
              video = document.getElementById('caller-video')
              video.src = vendorURL ? vendorURL.createObjectURL(callerStream) : callerStream
              video.play()
            })
          })
        }
      })
    }
  }
}
</script>

<style lang="sass">
.black-swan {
  h1 {
    text-align: center;
  }
  #user-details {
    display: flex;
    align-items: center;
    justify-content: center;
    .md-input-container {
      width: 50%;
    }
  }
  #your-message {
    position: fixed;
    bottom: 0;
    left: 250px;
    right: 0;
    background: white;
    padding: 15px;
    input {
      width: 100%;
      padding: 5px 8px;
      border-radius: 3px;
      outline: 0;
      border: 1px solid #ddd;
      font-size: 16px;
      font-family: Roboto;
    }
  }
}
</style>
