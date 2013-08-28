class Setup < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column 'email',           :string,  :limit => 60,   :default => '',         :null => false
      t.column 'kind',            :string,                  :default => 'learner',  :null => false
      t.column 'hashed_password', :string,  :limit => 40,   :default => ''
      t.column 'salt',            :string,  :limit => 64
      t.column 'last_login',      :datetime
      t.column 'team_id',         :integer

      t.timestamps
    end

    create_table :teams do |t|
      t.column 'name',            :string,  :limit => 100,                          :null => false

      t.timestamps
    end

    create_table :quizzes do |t|
      t.column 'name',            :string,  :limit => 100,                          :null => false

      t.timestamps
    end

    create_table :questions do |t|
      t.column 'title',           :text,                                            :null => false
      t.column 'quiz_id',         :integer,                                         :null => false

      t.timestamps
    end

    create_table :answers do |t|
      t.column 'title',           :text,                                            :null => false
      t.column 'question_id',     :integer,                                         :null => false
      t.column 'correct',         :boolean,                 :default => false,      :null => false

      t.timestamps
    end

    create_table :results do |t|
      t.column 'user_id',         :integer,                                         :null => false
      t.column 'quiz_id',         :integer,                                         :null => false
      t.column 'percent',         :integer,                 :default => 0,          :null => false
      t.column 'details',         :text,                                            :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
    drop_table :teams
    drop_table :quizzes
    drop_table :questions
    drop_table :answers
    drop_table :results
  end
end
