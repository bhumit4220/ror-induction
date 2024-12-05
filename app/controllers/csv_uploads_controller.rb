class CsvUploadsController < ApplicationController
  def new
    @csv_upload = CsvUpload.new
  end

  def create
    @csv_upload = CsvUpload.new(csv_upload_params)

    if @csv_upload.save
      # Ensure the file is attached
      if @csv_upload.file.attached?
        # Process the uploaded file
        table_name = "dynamic_tables"

        # Use ActiveStorage's open method to get a Tempfile
        @csv_upload.file.open do |file|
          DynamicTableService.new(file.path, table_name).process_csv
        end

        redirect_to new_csv_upload_path, notice: "CSV file uploaded and processing started."
      else
        flash[:alert] = "No file was attached. Please upload a file."
        render :new
      end
    else
      render :new
    end
  end

  private

  def csv_upload_params
    params.require(:csv_upload).permit(:file)
  end
end
