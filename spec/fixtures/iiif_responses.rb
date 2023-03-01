# frozen_string_literal: true

module IiifResponses

  def test_manifest1
    {
      "@id": 'uri://for-manifest1',
      "@type": 'sc:Manifest',
      label: 'Test Manifest 1',
      attribution: 'Attribution Data',
      description: 'A test IIIF manifest',
      license: 'http://www.example.org/license.html',
      metadata: [
        {
          label: 'Author',
          value: 'Kilgore Trout'
        },
        {
          label: 'Location',
          value: ["Portland >> Clackamas/Multnomah/Washington Counties >> Oregon >> United States"]
        }
      ],
      thumbnail: {
        "@id": 'uri://to-thumbnail'
      },
      sequences: [
        {
          "@type": 'sc:Sequence',
          canvases: [
            {
              "@type": 'sc:Canvas',
              images: [
                {
                  "@type": 'oa:Annotation',
                  resource: {
                    "@type": 'dcterms:Image',
                    "@id": 'uri://full-image',
                    service: {
                      "@id": 'uri://to-image-service'
                    }
                  }
                }
              ]
            }
          ]
        }
      ]
    }.to_json
  end
end
