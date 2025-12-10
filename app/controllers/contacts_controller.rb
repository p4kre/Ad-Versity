class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = Contact.all
    @contacts = @contacts.search(params[:search]) if params[:search].present?
    @contacts = @contacts.by_company(params[:company]) if params[:company].present?
    @contacts = @contacts.order(:first_name, :last_name)
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to @contact, notice: "Contact created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: "Contact updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    contact_name = "#{@contact.first_name} #{@contact.last_name}"
    @contact.destroy
    redirect_to contacts_path, notice: "Contact '#{contact_name}' has been deleted successfully."
  rescue => e
    redirect_to contacts_path, alert: "Failed to delete contact: #{e.message}"
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(
      :first_name, :last_name, :email, :job_title, :company,
      :age_range, :gender, :income_range, :education_level, 
      :occupation, :marital_status, :family_status
    )
  end
end
