import consumer from "./consumer";
const metaTag = document.querySelector('meta[name="current-user-id"]');
if (metaTag) {
    const currentUserId = metaTag.content;
    console.log(currentUserId, 'from meta tag');
    
    consumer.subscriptions.create({ channel: "NotificationChannel", id: currentUserId }, {
      connected() {
        console.log(`Connected to notification`)
      },
      disconnected() {
        console.log("Disconnected from notification.")
      },
      received(data) {
        const { sender_id, message, timestamp } = data;
        const userElement = document.querySelector(`[data-user-id="${sender_id}"]`);
        if (userElement) {
            const childElement = userElement.children[0];
            childElement.classList.remove("active-user");
            childElement.classList.add("unread-message");
          const parent = userElement.parentElement;
          parent.prepend(userElement);
        }
      }
    });
} else {
  console.log('No meta tag found');
}
