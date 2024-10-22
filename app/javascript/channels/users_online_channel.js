import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer();

consumer.subscriptions.create("UsersOnlineChannel", {
  received(data) {
    const userElement = document.getElementById(`user_${data.user_id}`);
    if (userElement) {
      if (data.online) {
        userElement.classList.add("badge-success");
      } else {
        userElement.classList.remove("badge-success");
      }
    }
  }
});
