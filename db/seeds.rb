question = Question.create!(
  [
    { title: 'Тип данных, которого нет в Ruby',
      body: 'body body body 1' },
    { title: 'Тип данных, которого нет в Javascript',
      body: 'body body body 2' },
    { title: 'Тип данных, которого нет в Go',
      body: 'body body body 3' },
    { title: 'Тип данных, которого нет в Java',
      body: 'body body body 4' },
    { title: 'Тип данных, которого нет в C#',
      body: 'body body body 5' }

  ]
)

question.first.answers.create!(
  [
    {
      body: 'Answer 1'
    },
    {
      body: 'Answer 2'
    },
    {
      body: 'Answer 3'
    },
    {
      body: 'Answer 4'
    },
    {
      body: 'Answer 5'
    }
  ]
)
