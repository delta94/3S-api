class BookingApi < ApiV1
  namespace :booking do
    before do
      authenticated
    end

    desc "User book a place"
    params do
      requires :start_date, :end_date, type: String, message: I18n.t("messages.errors.required")
      requires :num_of_people, type: Integer, message: I18n.t("messages.errors.required")
      requires :place_id, type: Integer, message: I18n.t("messages.errors.required")
    end
    post "/new" do
      data = valid_params params, Booking::BOOKING_PARAMS
      place = Place.find_by id: params[:place_id]
      data[:start_date] = Date.parse params[:start_date]
      data[:end_date] = Date.parse params[:end_date]
      data[:user_id] = current_user.id
      data[:payment_gateway] = nil
      data[:status] = "pending"
      coupon = Coupon.find_by code_name: params[:coupon_code]
      data[:price] = Booking.charge params[:start_date], params[:end_date], place
      data[:price] = data[:price] * (1 - coupon.discount / 100) if coupon

      booking = Booking.new data

      if booking.valid?
        booking.save

        return render_success_response(:ok, BookingResFormat, {data: booking}, I18n.t("messages.success.booking"))
      end

      error!(booking.errors.full_messages[0], :bad_request)
    end

    desc "Get booking by user"

    params do
      requires :id, type: Integer
    end

    get "/user/:id" do
      bookings = Booking.where user_id: params[:id]

      return render_success_response(:ok, BookingResFormat, {data: bookings}, "success") if bookings

      error!(booking.errors.full_messages[0], :bad_request)
    end

    desc "Get booking by place"

    params do
      requires :id, type: Integer
    end

    get "/place/:id" do
      bookings = Booking.where place_id: params[:id]

      return render_success_response(:ok, BookingResFormat, {data: bookings}, "success") if bookings

      error!(booking.errors.full_messages[0], :bad_request)
    end

    desc "Get all bookings by host"

    params do
      requires :id, type: Integer
    end

    get "/host/:id" do
      place_id = Place.where(user_id: params[:id]).ids
      results = []

      place_id.each do |id|
        booking = Booking.where(place_id: id)

        results.concat(booking)
      end

      return render_success_response(:ok, BookingResFormat, {data: results}, "success") if results

      error!("error", :bad_request)
    end
  end
end
