document.addEventListener("turbolinks:load", function () {
  const answers = document.querySelector(".answers");
  if (answers) {
    answers.addEventListener("click", answerEditHandler);
  }
});

function answerEditHandler(e) {
  const link = e.target.closest(".edit-answer-link");

  if (!link) return;

  e.preventDefault();
  link.classList.add("hidden");
  const answerId = link.dataset.answerId;

  document
    .querySelector(`form#edit-answer-${answerId}`)
    .classList.remove("hidden");
}
