File /rdsi/PRIVATE/raad/data/podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2017/118/20170428090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc (NC_FORMAT_NETCDF4):

     5 variables (excluding dimension variables):
        short analysed_sst[lon,lat,time]   (Chunking: [2047,1023,1])  (Compression: shuffle,level 7)
            long_name: analysed sea surface temperature
            standard_name: sea_surface_foundation_temperature
            units: kelvin
            _FillValue: -32768
            add_offset: 298.15
            scale_factor: 0.001
            valid_min: -32767
            valid_max: 32767
            comment: Interim near-real-time (nrt) version using Multi-Resolution Variational Analysis (MRVA) method for interpolation; to be replaced by Final version
            coordinates: lon lat
            source: AMSR2-REMSS, AVHRR19_G-NAVO, AVHRR_METOP_A-EUMETSAT, iQUAM-NOAA/NESDIS, Ice_Conc-OSISAF
        short analysis_error[lon,lat,time]   (Chunking: [2047,1023,1])  (Compression: shuffle,level 7)
            long_name: estimated error standard deviation of analysed_sst
            units: kelvin
            _FillValue: -32768
            add_offset: 0
            scale_factor: 0.01
            valid_min: 0
            valid_max: 32767
            comment: none
            coordinates: lon lat
        byte mask[lon,lat,time]   (Chunking: [2895,1447,1])  (Compression: shuffle,level 7)
            long_name: sea/land field composite mask
            _FillValue: -128
            valid_min: 1
            valid_max: 31
            flag_masks: 1
             flag_masks: 2
             flag_masks: 4
             flag_masks: 8
             flag_masks: 16
            flag_values: 1
             flag_values: 2
             flag_values: 5
             flag_values: 9
             flag_values: 13
            flag_meanings: 1=open-sea, 2=land, 5=open-lake, 9=open-sea with ice in the grid, 13=open-lake with ice in the grid
            comment: mask can be used to further filter the data.
            coordinates: lon lat
            source: GMT "grdlandmask", ice flag from sea_ice_fraction data
        byte sea_ice_fraction[lon,lat,time]   (Chunking: [2895,1447,1])  (Compression: shuffle,level 7)
            long_name: sea ice area fraction
            standard_name: sea ice area fraction
            units: fraction (between 0 and 1)
            _FillValue: -128
            add_offset: 0
            scale_factor: 0.01
            valid_min: 0
            valid_max: 100
            source: EUMETSAT OSI-SAF, copyright EUMETSAT
            comment: ice data interpolated by a nearest neighbor approach.
            coordinates: lon lat
        byte dt_1km_data[lon,lat,time]   (Chunking: [2895,1447,1])  (Compression: shuffle,level 7)
            long_name: time to most recent 1km data
            standard_name: time to most recent 1km data
            units: hours
            _FillValue: -128
            valid_min: -127
            valid_max: 127
            source: MODIS and VIIRS pixels ingested by MUR
            comment: The grid value is hours between the analysis time and the most recent MODIS or VIIRS 1km L2P datum within 0.01 degrees from the grid point.  "Fill value" indicates absence of such 1km data at the grid point.
            coordinates: lon lat

     3 dimensions:
        time  Size:1
            long_name: reference time of sst field
            standard_name: time
            axis: T
            units: seconds since 1981-01-01 00:00:00 UTC
            comment: Nominal time of analyzed fields
        lat  Size:17999
            long_name: latitude
            standard_name: latitude
            axis: Y
            units: degrees_north
            valid_min: -90
            valid_max: 90
            comment: none
        lon  Size:36000
            long_name: longitude
            standard_name: longitude
            axis: X
            units: degrees_east
            valid_min: -180
            valid_max: 180
            comment: none

    47 global attributes:
        Conventions: CF-1.5
        title: Daily MUR SST, Interim near-real-time (nrt) product
        summary: A merged, multi-sensor L4 Foundation SST analysis product from JPL.
        references: http://podaac.jpl.nasa.gov/Multi-scale_Ultra-high_Resolution_MUR-SST
        institution: Jet Propulsion Laboratory
        history: near real time (nrt) version created at nominal 1-day latency.
        comment: Interim-MUR(nrt) will be replaced by MUR-Final in about 3 days; MUR = "Multi-scale Ultra-high Reolution"
        license: These data are available free of charge under data policy of JPL PO.DAAC.
        id: MUR-JPL-L4-GLOB-v04.1
        naming_authority: org.ghrsst
        product_version: 04.1nrt
        uuid: 27665bc0-d5fc-11e1-9b23-0800200c9a66
        gds_version_id: 2.0
        netcdf_version_id: 4.1
        date_created: 20170429T030428Z
        start_time: 20170428T090000Z
        stop_time: 20170428T090000Z
        time_coverage_start: 20170427T210000Z
        time_coverage_end: 20170428T210000Z
        file_quality_level: 1
        source: AMSR2-REMSS, AVHRR19_G-NAVO, AVHRR_METOP_A-EUMETSAT, iQUAM-NOAA/NESDIS, Ice_Conc-OSISAF
        platform: Aqua, DMSP, NOAA-POES, Suomi-NPP, Terra
        sensor: AMSR-E, AVHRR, MODIS, SSM/I, VIIRS, in-situ
        Metadata_Conventions: Unidata Observation Dataset v1.0
        metadata_link: http://podaac.jpl.nasa.gov/ws/metadata/dataset/?format=iso&shortName=MUR-JPL-L4-GLOB-v04.1
        keywords: Oceans > Ocean Temperature > Sea Surface Temperature
        keywords_vocabulary: NASA Global Change Master Directory (GCMD) Science Keywords
        standard_name_vocabulary: NetCDF Climate and Forecast (CF) Metadata Convention
        southernmost_latitude: -90
        northernmost_latitude: 90
        westernmost_longitude: -180
        easternmost_longitude: 180
        spatial_resolution: 0.01 degrees
        geospatial_lat_units: degrees north
        geospatial_lat_resolution: 0.01 degrees
        geospatial_lon_units: degrees east
        geospatial_lon_resolution: 0.01 degrees
        acknowledgment: Please acknowledge the use of these data with the following statement:  These data were provided by JPL under support by NASA MEaSUREs program.
        creator_name: JPL MUR SST project
        creator_email: ghrsst@podaac.jpl.nasa.gov
        creator_url: http://mur.jpl.nasa.gov
        project: NASA Making Earth Science Data Records for Use in Research Environments (MEaSUREs) Program
        publisher_name: GHRSST Project Office
        publisher_url: http://www.ghrsst.org
        publisher_email: ghrsst-po@nceo.ac.uk
        processing_level: L4
        cdm_data_type: grid
