class TermsController < ApplicationController
  before_action :set_term, only: [:show, :edit, :update, :destroy]

  # GET /terms
  # GET /terms.json
  def index

    if params[:academic_session]
      @selected_academic_session = params[:academic_session]
    else
      @selected_academic_session = session[:global_academic_session]
    end

    @terms = Term.all
    @term = Term.new
    authorize @terms
    @master_term = MasterTerm.all

    populate_school_sessions

  end

  # GET /terms/1
  # GET /terms/1.json
  def show
  end

  # GET /terms/new
  def new
    @term = Term.new
  end

  # GET /terms/1/edit
  def edit
  end

  # POST /terms
  # POST /terms.json
  def create
    school_session_id = params[:term][:academic_session_id]
     if school_session_id.to_i != 0
            # @yearly_term = YearlyTerm.new(yearly_term_params)
            # params[:terms].each do |key,value|
           
            #   @term = Term.find_or_initialize_by(:academic_session_id => school_session_id, :master_term_id =>key)
            #   terms_array = value.to_a
            #   @term.master_term_id = terms_array[0][1].to_i
            #   @term.start_date = terms_array[1][1]
            #   @term.end_date = terms_array[2][1]
            #   @term.save
            # end

          @a=params[:terms].to_a
          term1=@a[0][1].to_a
          term2=@a[1][1].to_a
          term3=@a[2][1].to_a

          if Date.parse(term1[1][1])<Date.parse(term1[2][1])  && Date.parse(term1[2][1])< Date.parse(term2[1][1]) && Date.parse(term2[1][1])<Date.parse(term2[2][1]) &&  Date.parse(term2[2][1])< Date.parse(term3[1][1]) && Date.parse(term3[1][1])<Date.parse(term3[2][1])
            
            params[:terms].each do |key,value|
                @term = Term.find_or_initialize_by(:academic_session_id => school_session_id, :master_term_id =>key)
                terms_array = value.to_a
                @term.master_term_id = terms_array[0][1].to_i
                @term.start_date = terms_array[1][1]
                @term.end_date = terms_array[2][1]
                @term.save
            end

            respond_to do |format|
              # sign out all users to maintain consistent terms, sessions etc.
              do_systemwide_sign_out
              
              format.html { redirect_to terms_path(school_session: school_session_id), notice: 'Term was successfully scheduled.' }
            end

          else
            redirect_to :back,alert: 'Please select dates in appropriate ranges'
          end

    else
            @new_school_session = AcademicSession.new
            @new_school_session.name = AcademicSession.find(session[:global_academic_session]).name.split("-").map{|x| x.to_i}.map{|x| x+1}.join("-")
            @new_school_session.is_current = false
            @new_school_session.start_date = Date.today # *TODO* this should be start of first term below
            @new_school_session.end_date = Date.today # *TODO* this should be end of last term below

            if @new_school_session.save

                @a=params[:terms].to_a
                term1=@a[0][1].to_a
                term2=@a[1][1].to_a
                term3=@a[2][1].to_a

                  if Date.parse(term1[1][1])<Date.parse(term1[2][1])  && Date.parse(term1[2][1])< Date.parse(term2[1][1]) && Date.parse(term2[1][1])<Date.parse(term2[2][1]) &&  Date.parse(term2[2][1])< Date.parse(term3[1][1]) && Date.parse(term3[1][1])<Date.parse(term3[2][1])

                       params[:terms].each do |key,value|
                        @term = Term.new
                        terms_array = value.to_a
                        @term.master_term_id = terms_array[0][1].to_i
                        @term.school_session_id = @new_school_session.id
                        @term.start_date = terms_array[1][1]
                        @term.end_date = terms_array[2][1]
                        @term.save
                      end
                    school_session_id = @new_school_session.id
                      respond_to do |format|
                      # sign out all users to maintain consistent terms, sessions etc.
                      do_systemwide_sign_out
                      
                      format.html { redirect_to terms_path(school_session: school_session_id), notice: 'Term was successfully scheduled.' }
                    end
                    
                    else
                      redirect_to :back,alert: 'Please select dates in appropriate ranges'
                    end 
              # params[:terms].each do |key,value|
              #   @term = Term.new
              #   terms_array = value.to_a
              #   @term.master_term_id = terms_array[0][1].to_i
              #   @term.school_session_id = @new_school_session.id
              #   @term.start_date = terms_array[1][1]
              #   @term.end_date = terms_array[2][1]
              #   @term.save
              # end

            end
      

             redirect_to :back
           
      end

              # respond_to do |format|

              # if  params[:terms]
               #what is the logic behind this?
              # @yearly_term.save
              # format.html { redirect_to terms_path(school_session: school_session_id), notice: 'Yearly term was successfully created.' }
              # format.json { render :show, status: :created, location: @yearly_term }
              # else
              #   format.html { render :new }
              #   format.json { render json: @yearly_term.errors, status: :unprocessable_entity }
              # end
              # end
  end

  # PATCH/PUT /terms/1
  # PATCH/PUT /terms/1.json
  def update
    respond_to do |format|
      if @term.update(term_params)
        format.html { redirect_to @term, notice: 'Term was successfully updated.' }
        format.json { render :show, status: :ok, location: @term }
      else
        format.html { render :edit }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.json
  def destroy
    @term.destroy
    respond_to do |format|
      format.html { redirect_to terms_url, notice: 'Term was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  def terms_new_scheduled

    @term = Term.new
    @master_term=MasterTerm.all

    if params[:academic_session_id].to_i != 0 
      @selected_academic_session = AcademicSession.find_by(:id=>params[:academic_session_id]).id 
    end

    populate_school_sessions
    respond_to do |format|
      format.js {render '/terms/js/new_schedule_after_change'}
    end

  end
  # def new_scheduled

  #   @term = Term.new
  #   @master_term=MasterTerm.all

  #   if params[:academic_session_id].to_i != 0 
  #     @selected_school_session = AcademicSession.find_by(:id=>params[:academic_session_id]).id 
  #   end
  #   @master_term=Term.where(:academic_session=> @selected_school_session)
  #   populate_school_sessions

  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_term
    @term = Term.find(params[:id])
  end

  def do_systemwide_sign_out

    # Term.run_rake("db:sessions:clear")

    sql = 'TRUNCATE sessions;'
    ActiveRecord::Base.connection.execute(sql)
    # sign_out :user
                      
    # for user in User.all
    #   sign_out user
    # end

  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def term_params
    params[:term]
  end

  def populate_school_sessions

    global_school_session_id = session[:global_academic_session]

    current_session = AcademicSession.find(global_school_session_id)
    existing_sessions = AcademicSession.all.order("id DESC").collect{|s| [s.name, s.id]}

    next_session_name = current_session.name.split("-").map{|x| x.to_i}.map{|x| x+1}.join("-")
    existing_session_names = AcademicSession.all.order("id DESC").collect{|s| s.name}


    if existing_session_names.include?(next_session_name)
      @academic_sessions = existing_sessions
    else
      next_session = [next_session_name, 0]
      @academic_sessions = existing_sessions.unshift next_session # do not remove the space between unshift and the array, it is catastrophic
    end

  end
end
