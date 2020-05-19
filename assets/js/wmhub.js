/// @ts-check
import { Socket, Channel } from 'phoenix';

/// @ts-ignore
const { SERVER_PATH } = process.env;

/**
 * WM Hub
 * 
 * @typedef {{ project_id: string, payment_pointers: [string] }} ProjectOptions
 */
function WmHub() {

    /**
     * @type {Socket}
     */
    let socketReference;

    /**
     * @type {Element}
     */
    let metatagReference;

    /**
     * @type {Channel}
     */
    let projectChannelReference;

    /**
     * Creates a socket;
     * 
     * @return {Socket}
     */
    function setupSocket() {
        const socket = new Socket(`ws://${SERVER_PATH}/monetization`, {});
        socket.connect()
    
        return socket;
    }

    /**
     * 
     * @param {ProjectOptions} options
     * @param {Socket} socket 
     */
    function setupChannel({ project_id }, socket) {
        const channel = socket.channel(`monetization:${project_id}`);

        channel.join()
            .receive("ok", ({ pointers: [paymentPointer]}) => {
                metatagReference = setupMetaTag(paymentPointer);
            })
            .receive("error", response => {
                throw new Error(`Failed to join project channel. Socket details: ${JSON.stringify(response)}`);
            });

        return channel;
    }

    /**
     * Subscribes to API events.
     * 
     * @param {Channel} channel
     */
    function subscribePointerEvents(channel) {
        channel.on('pointer-update', ({ pointers: [paymentPointer] }) => {
            if (metatagReference && paymentPointer) {
                metatagReference.setAttribute('content', paymentPointer);
            } else {
                metatagReference = setupMetaTag(paymentPointer);
            }
        });
    }

    /**
     * Streams monetization events
     * 
     * @param {Channel} channel
     */
    function setupMonetizationListeners(channel) {
        if (!document.monetization) {
            return channel.push('not_monetized', {});
        }
        document.monetization.addEventListener('monetizationpending', event => {
            channel.push('monetization_pending', { details: event.detail });
        });
        document.monetization.addEventListener('monetizationstart', event => {
            channel.push('monetization_started', { details: event.detail });
        });
        document.monetization.addEventListener('monetizationstop', event => {
            channel.push('monetization_stopped', { details: event.detail });
        });
        document.monetization.addEventListener('monetizationprogress', event => {
            channel.push('monetization_progress', { details: event.detail });
        });
    }

    /**
     * Creates the web moetization tag on page.
     * 
     * @param {string} paymentPointer
     */
    function setupMetaTag(paymentPointer) {
        const meta = document.createElement('meta');
        meta.setAttribute('name', 'monetization');
        meta.setAttribute('content', paymentPointer);

        document.head.appendChild(meta);
        
        return meta;
    }

    return {
        /**
         * Initializes a new project instance
         * 
         * @param {ProjectOptions} options
         */
        init: options => {
            try {
                socketReference = setupSocket();
                projectChannelReference = setupChannel(options, socketReference);

                subscribePointerEvents(projectChannelReference);
                setupMonetizationListeners(projectChannelReference);
            }
            catch (e) {
                console.error(e);
            }
        },
        destroy: () => {
            if (socketReference) {
                socketReference.disconnect();
                document.head.removeChild(metatagReference);
            }
        }
    }
}

// @ts-ignore
window.wmhub = new WmHub();