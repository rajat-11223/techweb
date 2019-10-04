class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]


  # GET /searches
  # GET /searches.json
  def index

      calculate_ranges 

      if params[:type] == "staff"  # searching for teacher

        @users = User.where(id: params[:id])
        # @reports = @users.map(&:reports)
        @reports = @users.map(&:reports).flatten.collect{|a| @find_range.include?(a.academic_session_id) ? a : nil}.compact.sort_by{|a| [a.submitted_at.blank? ? a.created_at : a.submitted_at , a.created_at] }.reverse

        @results = [['User', @users], ['Report', @reports]]
        
        @show_view = "user"

     
      elsif params[:type] == "student" # searching for student

        @students = Student.where(id: params[:id])
        
        @reports = @students.map(&:reports).flatten.collect{|a| @find_range.include?(a.academic_session_id) ? a : nil}.compact.sort_by{|a| [a.submitted_at.blank? ? a.created_at : a.submitted_at, a.created_at] }.reverse

        @results = [['Student', @students], ['Report', @reports]]

        @show_view = "student"

      else # Universal Search

        query = params[:q]

        if query.index(" ")
          lim = query.index(" ")
          term1 = query[0..lim]
          term2 = query[lim+1..-1]
        else
          term1 = query
          term2 = query
        end

        @users = User.order(:fname).where("fname LIKE ? OR lname LIKE ?", "%#{term1}%", "%#{term2}%")
        @students = Student.order(:fname).where("fname LIKE ? OR lname LIKE ?", "%#{term1}%", "%#{term2}%")

        @stud_reports = @students.map(&:reports).flatten.collect{|a| @find_range.include?(a.academic_session_id) ? a : nil}.compact
        @user_reports = @users.map(&:reports).flatten.collect{|a| @find_range.include?(a.academic_session_id) ? a : nil}.compact

        @reports = (@stud_reports + @user_reports).uniq.sort_by{|a| [a.submitted_at.blank? ? a.created_at : a.submitted_at , a.created_at] }.reverse

        @results = [['Student', @students], ['User', @users], ['Report', @reports]]

        @show_view = "univ"

      end
  end

  # POST /searches
  # POST /searches.json
  def create
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      # @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      # params[:search]
    end

    def calculate_ranges
        # set min and max years from academic sessions
        @year_range = []
        AcademicSession.all.each do |session|
          name = session.name.split("-").map{|x| x.to_i}
          @year_range << name.first << name.last
        end
        @year_range = @year_range.uniq 

        # set range based on params or default to range bounds
        @min_range = params[:range_min] || @year_range.first
        @max_range = params[:range_max] || @year_range.last

        if @min_range.to_i >= @max_range.to_i
          @max_range = @min_range
        end

        # set search range bounds
        @find_range = []
        AcademicSession.all.each do |session|
          name = session.name.split("-").map{|x| x.to_i}
          if name.first.to_i >= @min_range.to_i && name.last.to_i <= @max_range.to_i
            @find_range << session.id
          end
        end 
    end
end
