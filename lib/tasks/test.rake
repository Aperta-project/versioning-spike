namespace :spike do
  desc 'TODO'
  task versioning: :environment do
    LOREM = [
      'Est eaque eos at hic facere error sit necessitatibus.',
      'Labore et vel esse.',
      'Neque qui ullam qui aliquid quod ut aut.',
      'Dolores et eos velit ad qui.',
      'Itaque optio aut doloribus eius aliquam.',
      'Atque est optio id in earum praesentium.',
      'Temporibus aut velit voluptates ex asperiores.',
      'Iusto est dicta et.',
      'Deleniti veritatis dolore maiores.',
      'Corporis distinctio odio qui aspernatur placeat.',
      'Doloribus sequi tempore consequatur voluptatum dolor aut.',
      'Doloribus sint occaecati corrupti qui molestiae tempore ut laudantium.',
      'Repudiandae laborum aut est mollitia.',
      'Nesciunt quia consectetur dolores minus.',
      'Perspiciatis et saepe eos ullam.',
      'Ipsum eum ullam maiores natus.',
      'Eaque porro eum beatae minus qui autem perspiciatis necessitatibus.',
      'Et et placeat aut quo facilis.',
      'Veniam accusamus corporis nihil ut officiis voluptatem quo voluptas.',
      'Nobis fuga doloribus et autem impedit.',
      'Nostrum aut et tenetur maxime aut sunt.',
      'Eos vero ut fugit nisi.',
      'Enim dolorem quisquam dicta iusto.',
      'Qui maiores neque sed id et molestiae sapiente cupiditate.',
      'Ipsam possimus veniam ea nihil.',
      'Autem aut voluptatem debitis adipisci magni sed modi.',
      'Nemo veniam mollitia quia aut.',
      'Commodi deleniti vel autem repellendus error qui consectetur voluptates.',
      'Quam adipisci quidem recusandae delectus occaecati.',
      'Voluptatibus ratione harum ut quaerat cum modi.',
      'Saepe id rerum exercitationem qui.',
      'Et et facere dolores.',
      'Accusantium est harum ducimus itaque.',
      'Nesciunt aperiam pariatur ut dolor sit.',
      'Praesentium dicta autem deleniti asperiores dolor.',
      'Voluptate dolores commodi nesciunt.',
      'Maxime vero inventore mollitia fugit voluptatum.',
      'Ipsum quo voluptas vero et.',
      'Praesentium tempore possimus debitis non rerum animi rerum hic.',
      'Ut unde aut et omnis nostrum earum voluptatem.',
      'Dolore hic dolorem amet.',
      'Aut dolores sint sed et.',
      'Eaque quod possimus sint corporis ea.',
      'Voluptatum incidunt autem perspiciatis nihil.',
      'Minima eligendi ut adipisci velit eum.',
      'Inventore dolore reprehenderit corporis tempora.',
      'Molestiae animi et ab aut excepturi ad mollitia maiores.',
      'Aut libero qui nesciunt eum.',
      'Qui dignissimos enim voluptatem architecto nam sunt aut.',
      'Harum ratione consequatur dolorum sit.'
    ].freeze

    100000.times do
      p = Paper.create
      versions = p.versions
      v = versions.create
      answers = []
      1000.times do |i|
        answers << Answer.new(
            name: "metadata_#{i}",
            value: LOREM[rand(50)]
        )
      end
      res = Answer.import(answers)
      tvs = []
      res.ids.each do |id|
        tvs << VersionedAnswer.new(
          answer_id: id,
          version_id: v.id)
      end
      VersionedAnswer.import(tvs)
#      fail unless p.latest_version.answers.count == 1000
      4.times do
        v = p.versions.create
        Answer.transaction do
          p.latest_version.answers.order('RANDOM()').limit(1).each do |answer|
            answer.update(value: LOREM[rand(50)])
          end
        end
        STDOUT.write('.')
      end
      STDOUT.write('*')
    end
  end
end
