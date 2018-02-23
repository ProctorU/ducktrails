class CreatePetsAndKittens < ActiveRecord::Migration[5.1]
  def change
    create_pets
    create_kittens
  end

  def create_pets
    create_table :pets do |t|
      t.string :name
    end
  end

  def create_kittens
    create_table :kittens do |t|
      t.boolean :fluffy
    end
  end
end
