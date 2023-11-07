import AVFoundation

extension AVCaptureSession {
    var movieFileOutput: AVCaptureMovieFileOutput? {
        //0번은 비디오데이터아웃풋, 1번은 무비파일아웃풋
        guard self.outputs.count == 2 else {
            return nil
        }
        let output = self.outputs[1] as? AVCaptureMovieFileOutput
        return output
    }
    
    func getMovieInput(position: AVCaptureDevice.Position) throws -> AVCaptureDeviceInput {
        // Add video input
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            throw VideoError.device(reason: .unableToSetInput)
        }
        let input = try AVCaptureDeviceInput(device: device)
        guard self.canAddInput(input) else {
            throw VideoError.device(reason: .unableToSetInput)
        }
        return input
    }
    
    func addMovieFileOutput() throws -> Self {
        guard self.movieFileOutput == nil else {
            // return itself if output is already set
            return self
        }
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard self.canAddOutput(fileOutput) else {
            throw VideoError.device(reason: .unableToSetOutput)
        }
        
        self.addOutput(fileOutput)
        
        return self
    }
}
