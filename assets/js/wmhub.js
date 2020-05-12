import { Socket } from 'phoenix';

function WmHub() {
    let socket;
    let projectChannel;

    function setupSocket({ session_id, project_id }) {
        socket = new Socket('ws://localhost:4000/socket', {
            params: {
                sessionId: session_id 
            } 
        });

        projectChannel = socket
            .channel(`monetization:${project_id}`);

        projectChannel
            .join()
            .receive("ok", console.log);

        projectChannel.on('pointer-update', ({ pointers }) => {
            // TODO: update meta
        });
    }

    return {
        init: options => {
            setupSocket(options);
        }
    }
}

window.wmhub = new WmHub();