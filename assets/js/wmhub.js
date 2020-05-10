import { Socket } from 'phoenix';


const socket = new Socket('ws://localhost:4000/socket', {params: {sessionId: WMHub.session_id}});
const projectChannel = socket.channel(`monetization:${WMHub.project_id}`);
projectChannel.join()
    .receive("ok", console.log)
projectChannel.on('pointer-update', ({ pointers }) => {
    // TODO: update meta
});

// MAGIC!