require 'yaml/store'
require 'securerandom'

module Store
  class YAML
    include Singleton
    attr_accessor :store

    def initialize
      @store = ::YAML::Store.new 'RT.store'
    end

    def create(table)
      store.transaction do
        store[table.to_s] = []
      end
    end

    def truncate(table)
      create table
    end

    def destroy(table)
      store.transaction do
        store.delete(table.to_s)
      end
    end

    def exists?(table)
      select(table) != nil
    end

    def empty?(table)
      select(table).empty?
    end

    def insert(table, row)
      row[:id] = SecureRandom.hex 5
      store.transaction do
        store[table.to_s] << row
      end
      row
    end

    def find(table, id)
      data = store.transaction { store[table.to_s] }
      return nil if data.nil?
      data.each do |row|
        return row if row[:id] == id
      end
      nil
    end

    def select(table, params = {})
      data = store.transaction { store[table.to_s] }
      return nil if data.nil?
      data.delete_if do |row|
        !(params.select { |key, value| row[key] != value }).empty?
      end
    end

    def update(table, id, row)
      index = find_index(table, id)
      store.transaction do
        store[table.to_s][index] = row
      end
      row
    end

    def delete(table, id)
      index = find_index(table, id)
      store.transaction do
        store[table.to_s].delete_at(index)
      end
    end

    protected

    def find_index(table, id)
      data = store.transaction { store[table.to_s] }
      data.each_with_index do |row, i|
        return i if row[:id] == id
      end
      nil
    end
  end
end
