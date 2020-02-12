class CitiesController < ApplicationController
  
  def create
    @city = City.new(params[:city])

    if @city.save
      redirect_to "/ehdmin/cities", notice: "City created"
    else
      redirect_to "/ehdmin/cities", notice: "City NOT created"
    end
  end

  def edit
    @city = City.where(name: params[:id]).first    
  end
  
  def update
    @city = City.find(params[:id])
    
    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to "/ehdmin/cities", notice: 'city was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
     
  end
end
