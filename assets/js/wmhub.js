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

    function createMetaTag(paymentPointer) {
        const meta = document.createElement('meta');
        meta.setAttribute('name', 'monetization');
        meta.setAttribute('content', paymentPointer);
        document.head.appendChild(meta);
    }

    return {
        init: options => {
            setupSocket(options);
            createMetaTag(options.payment_pointers[0]);
        }
    }
}

window.wmhub = new WmHub();