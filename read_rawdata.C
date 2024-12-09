/// \file
/// \ingroup tutorial_tree
/// \notebook -js
/// Create can ntuple reading data from an ascii file.
/// This macro is a variant of basic.C
///
/// \macro_image
/// \macro_code
///
/// \author Rene Brun

void read_rawdata(TString filename) {
    //on NU1 PC
    /*TString dir = "/home/cvson/offline/daq/ir-remote-decoder/rawdata";
    TString dirroot = "/home/cvson/offline/daq/ir-remote-decoder/rootdata";*/
    
    /*TString dir = "/Users/cvson/meOffline/OBLM/ana2023nov/data/20231222_710kW_ssemout_ssem19in";
    TString dirroot = "/Users/cvson/meOffline/OBLM/ana2023nov/data/20231222_710kW_ssemout_ssem19in";
    */
    TString dir = "/Users/cvson/meOffline/DAQ/RTM3004/rawdata";
    TString dirroot = "/Users/cvson/meOffline/DAQ/RTM3004/rootdata";
    
    //TString filename ="";
    //dir.Append("/tree/");
    //dir.ReplaceAll("/./","/");
    
    TFile *f = new TFile(Form("%s/%s_convert.root",dirroot.Data(),filename.Data()),"RECREATE");
    TTree *T = new TTree("data","data from dat file");
    Long64_t nlines = T->ReadFile(Form("%s/%s.dat",dir.Data(),filename.Data()));
    printf(" found %lld points\n",nlines);
    T->Write();
}
