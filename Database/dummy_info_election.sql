USE virtual_elec_booth;

INSERT INTO Citizen_list (National_ID, Phone_no, DOB)
VALUES
    ('1101402304533', '0874929151', '2005-02-20')
    ;
    
    
INSERT INTO Candidate_list (name, img_path, party)
VALUES
    ('Prayat MakMak', 'akgbrviongveimg.png', 'Moving Backward'),
	('Pitak Salanghe', 'osjaokegneauevi.png', 'Sleeping In Class')
    ;
    

UPDATE result
SET number_voted = number_voted + 30
WHERE CandidateID = '2';