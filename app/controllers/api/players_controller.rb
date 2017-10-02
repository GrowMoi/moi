module Api
  class PlayersController < BaseController

    before_action :authenticate_user!

    respond_to :json

    expose(:player) {
      Player.find(params[:id])
    }

    expose(:player_test) {
      Player.find(params[:id]).learning_quiz
    }

    api :GET,
        "/quiz/:quiz_id/player/:player_id",
        "get new notifications for current user"
    example %q{
      "quiz": {
        'id': 132,
        'player_id': 23,
        'player_name': 'Moi User',
        'questions': [
          {
            'title': 'que es matematica 1',
            'content_id': 15,
            'media_url': 'null',
            'possible_answers': [
              {
                'id': 39,
                'text': 'correcta'
              },
              {
                'id': 40,
                'text': 'incorrecta'
              },
              {
                'id': 41,
                'text': 'incorrecta'
              }
            ]
          },
          {
            'title': 'como funciona matematica 1',
            'content_id': 16,
            'media_url': 'null',
            'possible_answers': [
              {
                'id': 42,
                'text': 'correcta'
              },
              {
                'id': 43,
                'text': 'incorrecta'
              },
              {
                'id': 44,
                'text': 'incorrecta'
              }
            ]
          },
          {
            'title': 'Como funciona 1?',
            'content_id': 2,
            'media_url': null,
            'possible_answers': [
              {
                'id': 2,
                'text': 'respuesta 1'
              },
              {
                'id': 15,
                'text': 'respuesta  2'
              },
              {
                'id': 16,
                'text': 'respuesta  3'
              }
            ]
          },
          {
            'title': 'Geoogia1',
            'content_id': 20,
            'media_url': 'null',
            'possible_answers': [
              {
                'id': 53,
                'text': 'correcta'
              }
            ]
          }
        ]
      }
    }

    def show
      render json: {
        quiz_id: player.quiz_id,
        player_name: player.name,
        player_id: player.id,
        questions: quiz_fetcher.player_test_for_api,
        answers: player_test.answers,
        time: timeQuiz * 1000 #miliseconds
      }
    end

    def answer
      answerer_result = answerer.result
      render json: {
        result: answerer_result
      }
    end

    private

    def answerer
      TreeService::AnswerQuiz.new(
        player_test: player_test,
        answers: JSON.parse(params[:answers])
      ).process!
    end

    def quiz_fetcher
      @quiz_fetcher ||= TreeService::QuizFetcher.new(
        player
      )
    end

    def timeQuiz
      player_test.updated_at - player_test.created_at
    end

  end
end
