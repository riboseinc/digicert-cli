require "spec_helper"

RSpec.describe Digicert::CLI::CertificateDownloader do
  describe ".download" do
    it "downloads the certificate to the specified path" do
      certificate_id = 123_456_789
      allow(File).to receive(:open)
      mock_digicert_certificate_download_api(certificate_id)

      Digicert::CLI::CertificateDownloader.download(
        print_enable: false,
        path: download_path,
        certificate_id: certificate_id,
      )

      expect(File).to have_received(:open).thrice
    end
  end

  def download_path
    File.expand_path("../../tmp", __FILE__).to_s
  end

  def mock_digicert_certificate_download_api(certificate_id)
    stub_digicert_certificate_download_by_format(
      certificate_id, "pem_all", "pem"
    )
  end
end
