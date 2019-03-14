package userdata_cache_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("userdata cache Full", func() {

	It("verify userdata cache when building stemcell", func() {
		
		stdOut, _, _, err := bosh.Run(
			"ssh",
			"test/0",
			`sudo ls /var/vcap/bosh/userdata_cache.json`,
		)
		Expect(err).ToNot(HaveOccurred())
		Expect(stdOut).ToNot(ContainSubstring("No such file or directory"))
	})

	
})
