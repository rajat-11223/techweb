class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  # GET /subjects
  # GET /subjects.json
  def index
    @curriculum_subjects = Subject.all.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false, is_ppa: false)
    @core_subjects = Subject.all.where(is_core: true, is_pivats: false)
    authorize @curriculum_subjects

    @subject = Subject.new
    @subject.sub_subjects.build
  # authorize @curriculum_subjects

  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
    @subject.sub_subjects.build
  end

  # GET /subjects/1/edit
  def edit

  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(subject_params)
    respond_to do |format|
      if @subject.save
        @sub_subject= SubSubject.new
        @sub_subject.subject_id=@subject.id
        @sub_subject.name=@subject.name
        @sub_subject.is_none=true
        @sub_subject.save

        format.html { redirect_to subjects_path, notice: @subject.name + ' was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    if Subject.find_by(:id=>params[:id]).is_core
      respond_to do |format|
        if @subject.update(subject_params)
          format.html { redirect_to subjects_path+"#tab_tab2", notice: @subject.name + ' was successfully updated.' }
          format.json { render :show, status: :ok, location: @subject }
        else
          format.html { render :edit }
          format.json { render json: @subject.errors, status: :unprocessable_entity }
        end
      end
    else

      respond_to do |format|
        if @subject.update(subject_params)
          format.html { redirect_to subjects_path, notice: @subject.name + ' was successfully updated.' }
          format.json { render :show, status: :ok, location: @subject }
        else
          format.html { render :edit }
          format.json { render json: @subject.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    if Subject.find_by(:id=>params[:id]).is_core

      @subject.destroy
  #*TODO* need to delete sub sujects too?
  respond_to do |format|
    format.html { redirect_to subjects_path+"#tab_core", notice: @subject.name + ' was successfully deleted.' }
    format.json { head :no_content }
  end
  else
    @subject.destroy
  #*TODO* need to delete sub subjects too?
  respond_to do |format|
    format.html { redirect_to subjects_path, notice: @subject.name + ' was successfully deleted.' }
    format.json { head :no_content }
  end
  end
  end

  # custom methods
  # delete sub-subject
  def delete_sub_subject
    @sub_subject=SubSubject.find_by(:id=>params[:id])
    @sub_subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: @sub_subject.show_name + ' was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  # end////
  # edit subjet
  def edit_subject

    @subject=Subject.find_by(:id=>params[:subject_id])


    respond_to do |format|
      format.js {render '/subjects/js/edit_subject'}
    end
  end



  def create_core_subject
    @subject=Subject.new
    @subject.name=params[:subject][:name]
    @subject.is_core = true
    respond_to do |format|
      if @subject.save
        format.html { redirect_to subjects_path+"#tab_core", notice: @subject.name + ' was successfully created.' }
      end
    end

  end

  def edit_core_subject
    @subject=Subject.find_by(:id=>params[:subject_id])


    respond_to do |format|
      format.js {render '/subjects/js/edit_core_subject'}
    end
  end
  # end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_subject
    @subject = Subject.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subject_params
    params[:subject].permit(:name,:display_name,:is_pfc,:is_ppa,:is_core,:position, sub_subjects_attributes:
      [:id ,:subject_id,:name,:display_name,:is_core,:is_pfc,:is_tutorial,:is_none,:position,:_destroy
      ]
      )
  end
end
