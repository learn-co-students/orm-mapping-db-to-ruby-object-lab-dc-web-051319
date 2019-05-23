require 'sqlite3'
require_relative '../lib/student'
require 'pry'
 
DB = {:conn => SQLite3::Database.new("db/students.db")}

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    return new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(new_name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    x = DB[:conn].execute(sql, new_name)[0]

    self.new_from_db(x)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 9
    SQL
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE NOT grade = 12
    SQL
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10
    SQL

    array = []
    DB[:conn].execute(sql).collect do |row|
      array << self.new_from_db(row)
    end
    return array[0..num-1]
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10
    SQL
    
    array = []
    DB[:conn].execute(sql).each do |row|
      array << self.new_from_db(row)
    end
    return array[0]
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    
    DB[:conn].execute(sql, num).each do |row|
      self.new_from_db(row)
    end
  end



end
