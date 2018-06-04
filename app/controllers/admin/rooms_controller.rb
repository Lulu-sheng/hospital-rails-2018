class Admin::RoomsController < Admin::BaseController
  layout 'admin/layouts/index_layout', only: [:index, :sort]
  def index
    @rooms = Room.all
  end

  def create
    @room = Room.new(room_params)
    respond_to do |format|
      if @room.save
        format.html { flash[:success] = 'Room was successfully created'
                      redirect_to admin_rooms_path }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    room = Room.find(params[:id])

    dependent = false
    Patient.all.each do |patient|
      if patient.room_id.to_s.eql?(params[:id])
        dependent = true
      end
    end

    respond_to do |format|
      if !dependent && room.destroy
        format.html { flash[:success] = 'Room was successfully removed from the system'
                      redirect_to admin_rooms_url}
      else
        format.html {flash[:warning] = 'This room is still being occupied by other patients'
                     redirect_to admin_rooms_url }
      end
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])

    respond_to do |format|
      if @room.update(room_params)
        format.html { flash[:success] = 'Room was successfully updated'
                      redirect_to admin_rooms_path }
      else
        format.html { render :edit }
      end
    end
  end
  
  def summary
    @patients_per_floor_hash =Patient.joins(:room).group(:floor).count(:id)
    @vip_per_floor_hash = Room.where(vip: true).group(:floor).count(:id)
    @rooms_per_floor_hash = Room.group(:floor).count(:id)
  end

  def sort
    @rooms = Room.all.order(number: :asc)
    render 'index'
  end

  def new
    @room = Room.new
  end

  private
  def room_params
    params.require(:room).permit(:wing, :floor, :number, :vip)
  end

  def invalid_room
    logger.error "Attempt to access invalid room #{params[:id]}"
    flash[:warning] = 'Invalid room'
    redirect_to admin_rooms_url
  end
end
