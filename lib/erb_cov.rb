class ErbCov
  def self.diff
    read = File.read('tmp/rendered_erb').split("\n").uniq
    all =Dir.glob(Rails.root.join("app","views","**/*.erb"))
    (all-read).sort
  end
end
