# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tags = %w[いぬ ねこ 小動物 鳥 爬虫類 その他 相談 質問]
tags.each do |tag|
  Tag.find_or_create_by(name: tag)
end

# ユーザー一覧
users = [
    {email: 'user1@example.com', password: 'password', nickname: 'ユーザー1'},
    {email: 'user2@example.com', password: 'password', nickname: 'ユーザー2'},
    {email: 'user3@example.com', password: 'password', nickname: 'ユーザー3'},
    {email: 'user4@example.com', password: 'password', nickname: 'ユーザー4'},
    {email: 'user5@example.com', password: 'password', nickname: 'ユーザー5'},
    {email: 'user6@example.com', password: 'password', nickname: 'ユーザー6'},
]

# ユーザーに紐づけるペット一覧
pets = [
    {name: '小次郎', gender: 'オス', kind: '柴犬'},
    {name: '武蔵', gender: 'メス', kind: '柴犬'},
    {name: 'しらす', gender: 'メス', kind: '柴犬'},
    {name: 'あおい', gender: 'メス', kind: '猫'},
    {name: 'ゴロピー', gender: '不明', kind: 'ヒョウモントカゲモドキ'},
    {name: 'もも', gender: 'オス', kind: 'ネザーランドドワーフ'},
    {name: 'くぅ', gender: 'メス', kind: 'オカメインコ'},
]

# 投稿一覧
posts = [
    {title: 'お世話の方法', content: 'お世話の方法について知りたいです。',
        post_comments: [
            {comment: 'トリミングが大切です。'},
            {comment: '日々の運動が大切です。'},
            {comment: 'もう少し具体的に教えてください！'}
        ],
        tags: Tag.where(name: ['ねこ', '相談']).ids
    },
    {title: 'お散歩について', content: '日々のお散歩について知りたいです。',
        post_comments: [
            {comment: 'ゆっくりと歩いてあげると良いです。。'},
            {comment: '草むらが好きでよく入りますが、ひっつき虫だらけになります。'}
        ],
        tags: Tag.where(name: ['いぬ', '質問']).ids
    },
    {title: '食事について', content: '健康的な食事の方法について知りたいです。',
        post_comments: [
            {comment: '味の濃いものは避けましょう。'},
            {comment: 'ペットフードでもバランスの良いものを選びましょう。'},
            {comment: '人間食は基本NGです。'},
            {comment: '手間ですが、手作り食が一番ですね。'}
        ],
        tags: Tag.where(name: ['鳥', '質問']).ids
    },
    {title: '運動について', content: 'パークでの運動について知りたいです。',
        post_comments: [
            {comment: '他の人に迷惑にならない程度にお気に入りのおもちゃを持っていくと良いです。'},
            {comment: '他の子と喧嘩にならないようにしっかりと見ておくのも大切です。'}
        ],
        tags: Tag.where(name: ['犬', '質問', '相談']).ids
    },
    {title: 'うさぎのあるある', content: 'ウサギは臆病で安全な環境が必要。食事は高い野菜が必須。規則正しい清潔なケアが重要。定期的な健康チェックが必要。足運動と遊びがストレス解消になります。',
        post_comments: [
            {comment: '参考になります！'},
            {comment: 'ストレスケア大切ですよね。'}
        ],
        tags: Tag.where(name: ['小動物']).ids
    },
    {title: '助けてください', content: 'レオパのご飯で生き餌が良いらしいのですが、生きた昆虫が無理です・・・。どうしたら良いですか？',
        post_comments: [
            {comment: '冷凍された物も販売していますよ！'},
            {comment: '私は仕方がないと、諦めて腹括ってます！'}
        ],
        tags: Tag.where(name: ['爬虫類', '質問', '相談']).ids
    }
]

users.each do |user|
    # ユーザー作成
    user_data = User.find_or_create_by(email: user[:email]) do |u|
        u.password = user[:password]
        u.nickname = user[:nickname]
    end

    user_data.pets.find_or_create_by(pets.sample) # ランダムにペットを割り当てる

    # 最大4件のpostを作る(重複なし)
    (1..4).each do |n|
        post = posts.sample # postsからランダムに取得
        post_data = user_data.posts.find_or_initialize_by(title: post[:title]) # postのnew
        if post_data.new_record? # postに重複がなければ
            post_data.save(validate: false) # バリデーションを無視して登録(ActionText対策)
            ActionText::RichText.create(record_type: 'Post', record_id: post_data.id, name: 'content', body: post[:content]) # ActionTextの登録

            # コメント一覧を配列で生成する(map)
            post_comments = post[:post_comments].map do |post_comment|
                {
                    user_id: rand(1..users.count),
                    post_id: post_data.id,
                    comment: post_comment[:comment],
                    created_at: Time.current,
                    updated_at: Time.current
                }
            end

            PostComment.insert_all post_comments # コメント一覧で生成した配列をバルクインサート(after_create対策)

            # タグの関連づけ
            post[:tags].each do |tag|
                post_data.post_tags.create(post_id: post_data.id, tag_id: tag)
            end
        end
    end
end