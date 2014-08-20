class CreateUsersTestsQuestionsAnswers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string	:username
  		t.string	:email
  		t.string	:password_salt
  		t.string	:password_hash

  		t.timestamps
  	end

  	create_table :tests do |t|
  		t.belongs_to :user
  		t.string	:test_name
  		
  		t.timestamps
  	end

  	create_table :questions do |t|
  		t.belongs_to	:test
  		t.string	:question_title
  	end

  	create_table :answers do |t|
  		t.belongs_to	:question
  		t.string	:a
  		t.string	:b
  		t.string	:c
  		t.string	:d
  	end
  end
end
