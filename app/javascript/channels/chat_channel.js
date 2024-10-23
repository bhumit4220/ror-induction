import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()
const chatChannels = {};

function createChatChannel(senderId, receiverId) {
  const channelKey = `chat_${senderId}_${receiverId}`;

  if (chatChannels[channelKey]) {
    console.log(`Reusing existing channel for ${senderId} and ${receiverId}`);
    return chatChannels[channelKey];
  }

  console.log(`Creating new channel for ${senderId} and ${receiverId}`);

  const newChannel = consumer.subscriptions.create(
    { channel: "ChatChannel", sender_id: senderId, receiver_id: receiverId },
    {
      connected() {
        console.log(`Connected to chat between ${senderId} and ${receiverId}`)
      },
      disconnected() {
        console.log("Disconnected from chat.")
      },
      received(data) {
        const messagesContainer = document.getElementById('messages');
        const messageId = data.message.id;
        if (messagesContainer) {  
          const lastMessage = messagesContainer.lastElementChild;
          if (!lastMessage || lastMessage.dataset.id !== data.message_id) {
            messagesContainer.insertAdjacentHTML('beforeend', data.message);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
          }
          moveUserToTop(data.user_id, data.top);
        }
      },
      speak(message) {
        this.perform("speak", {
          sender_id: senderId,
          receiver_id: receiverId,
          message: message
        })
      }
    }
  )

  function moveUserToTop(userId, top) {
    const userElement = document.querySelector(`[data-user-id="${userId}"]`);
    if (userElement) {
      if (top) {
        const childElement = userElement.children[0];
        childElement.classList.remove("active-user");
        childElement.classList.add("unread-message");
      }
      const parent = userElement.parentElement;
      parent.prepend(userElement);
    }
  }

  chatChannels[channelKey] = newChannel;
  return newChannel;

}

window.createChatChannel = createChatChannel
